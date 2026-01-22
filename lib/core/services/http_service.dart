import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../features/auth/data/models/server_request.dart';
import '../app/api_endpoints.dart';
import '../app/api_method.dart';
import 'http_interface.dart';
import '../../utils/helpers/snackbar_service.dart';
import 'package:get/get.dart';

class HttpService implements IHttp {
  @override
  Future<ServerRequest> requestHttp({
    required APIMethod method,
    required String endpoint,
    Map<String, String>? headers,
    Map<String, String>? params,
    Map<String, dynamic>? body,
    required BuildContext context,
    bool isAuthenticationRequired = false,
    bool showSnackBarOnSuccess = false,
    bool isDevEnv = false,
    String? filePath,
    String? fileFieldName,
    // Add these new parameters for web support
    Uint8List? fileBytes,
    String? fileName,
  }) async {
    ServerRequest serverResponse = ServerRequest(statusCode: 0, response: null);

    try {
      headers ??= {'Content-Type': 'application/json'};

      late String apiMethod;
      switch (method) {
        case APIMethod.post:
          apiMethod = "POST";
          break;
        case APIMethod.get:
          apiMethod = "GET";
          break;
        case APIMethod.delete:
          apiMethod = "DELETE";
          break;
        case APIMethod.put:
          apiMethod = "PUT";
          break;
      }

      endpoint = '${ApiEndpoints.devUrl}${ApiEndpoints.base}$endpoint';

      log(
        "[http_service.dart -> requestHttp()] Sending '$apiMethod' Request to | endpoint: $endpoint'...",
      );

      Uri uri = Uri.parse(endpoint);

      // Add query parameters to the request if provided
      if (params != null) {
        log(
          "[http_service.dart -> requestHttp()] [$endpoint] Adding query parameters: $params...",
        );
        uri = uri.replace(queryParameters: params);
      }

      http.StreamedResponse response;

      // Check if this is a file upload request
      if (fileFieldName != null &&
          ((kIsWeb && fileBytes != null) || (!kIsWeb && filePath != null))) {
        log(
          "[http_service.dart -> requestHttp()] [$endpoint] Preparing multipart file upload...",
        );

        // Create MultipartRequest for file upload
        var request = http.MultipartRequest(apiMethod, uri);

        // Add file to request
        try {
          http.MultipartFile multipartFile;

          if (kIsWeb) {
            // For web: use bytes
            if (fileBytes == null) {
              throw Exception("File bytes are required for web file upload");
            }
            multipartFile = http.MultipartFile.fromBytes(
              fileFieldName,
              fileBytes,
              filename: fileName ?? 'file.csv',
            );
            log(
              "[http_service.dart -> requestHttp()] [$endpoint] Added file from bytes for web: ${fileName ?? 'file.csv'}",
            );
          } else {
            // For mobile/desktop: use file path
            if (filePath == null) {
              throw Exception(
                "File path is required for mobile/desktop file upload",
              );
            }
            multipartFile = await http.MultipartFile.fromPath(
              fileFieldName,
              filePath,
            );
            log(
              "[http_service.dart -> requestHttp()] [$endpoint] Added file from path: $filePath",
            );
          }

          request.files.add(multipartFile);
          log(
            "[http_service.dart -> requestHttp()] [$endpoint] File added successfully with field name: $fileFieldName",
          );
        } catch (e) {
          log(
            "[http_service.dart -> requestHttp()] [$endpoint] Error adding file: $e",
          );
          throw Exception("Failed to add file to request: $e");
        }

        // Add form fields if body is provided
        if (body != null) {
          body.forEach((key, value) {
            request.fields[key] = value.toString();
          });
          log(
            "[http_service.dart -> requestHttp()] [$endpoint] Added form fields: $body",
          );
        }

        // Remove Content-Type header for multipart requests (it will be set automatically)
        if (headers.containsKey('Content-Type')) {
          headers.remove('Content-Type');
        }

        // Add headers to multipart request
        request.headers.addAll(headers);

        log(
          "[http_service.dart -> requestHttp()] [$endpoint] Sending multipart request...",
        );
        response = await request.send();
      } else {
        // Regular HTTP request (existing logic)
        var request = http.Request(apiMethod, uri);

        if (body != null) {
          log(
            "[http_service.dart -> requestHttp()] [$endpoint] Appending Body: '$body'...",
          );
          request.body = json.encode(body);
        }

        request.headers.addAll(headers);
        response = await request.send();
      }

      log(
        "[http_service.dart -> requestHttp()] [$endpoint] Status Code: ${response.statusCode}",
      );

      serverResponse = ServerRequest(
        statusCode: response.statusCode,
        response: null,
      );

      log("[http_service.dart -> requestHttp()] Decoding JSON response...");
      serverResponse.response = json.decode(
        await response.stream.transform(utf8.decoder).join(),
      );
      log("Response: ${serverResponse.response}");
      log("[http_service.dart -> requestHttp()] JSON response decoded!");

      // Handle response status codes (your existing logic)
      switch (response.statusCode) {
        case 200 || 201:
          if (!showSnackBarOnSuccess) {
            log("[http_service.dart -> requestHttp()] Not Showing Snackbar...");
            return serverResponse;
          } else {
            SnackbarServiceHelper.showSuccess(
              "${serverResponse.response}",
              position: SnackPosition.BOTTOM,
              actionLabel: 'OK',
            );
            return serverResponse;
          }
        case 401:
          log(
            "[http_service.dart -> requestHttp()] Error: ${serverResponse.response}. Showing SnackBar...",
          );
          SnackbarServiceHelper.showError(
            '${serverResponse.response} - contact T4B team support',
            position: SnackPosition.BOTTOM,
            actionLabel: 'Dismiss',
            onActionPressed: () => Get.back(),
          );
          return serverResponse;
        case 400 || 404:
          log(
            "[http_service.dart -> requestHttp()] Error: ${serverResponse.response}. Showing SnackBar...",
          );
          SnackbarServiceHelper.showError(
            "${serverResponse.response} - contact T4B team support",
            position: SnackPosition.BOTTOM,
            actionLabel: 'Dismiss',
            onActionPressed: () => Get.back(),
          );
          return serverResponse;
        case 301:
          if (context.mounted) {
            log(
              "[http_service.dart -> requestHttp()] Error: ${serverResponse.response}. Showing SnackBar...",
            );
            SnackbarServiceHelper.showError(
              "${serverResponse.response} - contact T4B team support",
              position: SnackPosition.TOP,
              actionLabel: 'Dismiss',
              onActionPressed: () => Get.back(),
            );
          }
          return serverResponse;
        case 500:
          log(
            "[http_service.dart -> requestHttp()] Error: ${serverResponse.response}. Showing SnackBar...",
          );
          if (context.mounted) {
            SnackbarServiceHelper.showError(
              "${serverResponse.response} - contact T4B team support",
              position: SnackPosition.BOTTOM,
              actionLabel: 'Dismiss',
              onActionPressed: () => Get.back(),
            );
          }
          return serverResponse;
        default:
          return serverResponse;
      }
    } on FormatException {
      log(
        "[http_service.dart -> requestHttp()] A Format Exception error has occurred. Please review app logic.",
      );
      if (context.mounted) {
        SnackbarServiceHelper.showError(
          "$endpoint\nFormat Exception:",
          position: SnackPosition.BOTTOM,
          actionLabel: 'Dismiss',
          onActionPressed: () => Get.back(),
        );
      }
      return ServerRequest(statusCode: -1, response: null);
    } on http.ClientException {
      log("[http_service.dart -> requestHttp()] Error: Client Exception");
      if (context.mounted) {
        SnackbarServiceHelper.showWarning(
          "HTTP Client Exception: ",
          position: SnackPosition.BOTTOM,
          actionLabel: 'Dismiss',
          onActionPressed: () => Get.back(),
        );
      }
      return ServerRequest(statusCode: -2, response: null);
    } catch (e) {
      log("[http_service.dart -> requestHttp()] Error: $e");
      if (serverResponse.statusCode == 619) {
        // Maintenance
        if (context.mounted) {
          SnackbarServiceHelper.showInfo(
            "${serverResponse.response} - contact T4B team support",
            position: SnackPosition.BOTTOM,
            actionLabel: 'OK',
          );
        }
      } else {
        if (context.mounted) {
          SnackbarServiceHelper.showError(
            "${serverResponse.response} - contact T4B team support",
            position: SnackPosition.BOTTOM,
            actionLabel: 'Dismiss',
            onActionPressed: () => Get.back(),
          );
        }
      }
      return ServerRequest(statusCode: -3, response: null);
    }
  }
}
