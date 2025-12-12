import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../features/auth/data/models/server_request.dart';
import '../app/api_method.dart';

abstract class IHttp {
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
    Uint8List? fileBytes,
    String? fileName,
  });
}
