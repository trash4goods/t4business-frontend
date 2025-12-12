import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/core/services/http_interface.dart';

import '../../../../../../core/app/api_endpoints.dart';
import '../../../../../../core/app/api_method.dart';
import '../../models/manage_team.dart';
import '../../models/team.dart';
import 'department_managment_remote_datasource.interface.dart';

class DepartmentManagmentRemoteDatasourceImpl
    implements DepartmentManagmentRemoteDatasourceInterface {
  IHttp http;

  DepartmentManagmentRemoteDatasourceImpl(this.http);

  @override
  Future<void> inviteToDepartment(List<String> emails, String token) async {
    try {
      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.post,
        endpoint: ApiEndpoints.inviteToDepartment,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: {'emails': emails},
        isDevEnv: true,
      );
      log(
        '[DepartmentManagmentRemoteDatasourceImpl] inviteToDepartment response: ${response.response}',
      );
    } catch (e) {
      log(
        '[DepartmentManagmentRemoteDatasourceImpl] inviteToDepartment error: $e',
      );
      rethrow;
    }
  }

  @override
  Future<void> manageTeam(String token, TeamModel? team) async {
    try {
      log('sending as body: ${team?.toJson()}');
      await http.requestHttp(
        context: Get.context!,
        method: APIMethod.put,
        endpoint: ApiEndpoints.manageTeam,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: team?.toJson(),
        isDevEnv: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ManageTeamModel>> getDepartmentTeam(String token) async {
    try {
      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.get,
        endpoint: ApiEndpoints.getDepartmentTeam,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        isDevEnv: true,
      );

      if (response.statusCode == 200) {
        log(
          '[DepartmentManagmentRemoteDatasourceImpl] getDepartmentTeam response: ${response.response}',
        );
        return List.from(
          response.response,
        ).map((e) => ManageTeamModel.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      log(
        '[DepartmentManagmentRemoteDatasourceImpl] getDepartmentTeam error: $e',
      );
      return [];
    }
  }

  @override
  Future<void> leaveDepartment(String token) async {
    try {
      await http.requestHttp(
        context: Get.context!,
        method: APIMethod.post,
        endpoint: ApiEndpoints.leaveDepartment,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        isDevEnv: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> transferOwnership(String token, int newOwnerUserId) async {
    try {
      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.post,
        endpoint: ApiEndpoints.transferOwnership,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: {'new_owner_id': newOwnerUserId},
        isDevEnv: true,
      );

      if (response.statusCode == 200) {
        log(
          '[DepartmentManagmentRemoteDatasourceImpl] transferOwnership response: ${response.response}',
        );
        Get.snackbar(
          'Success',
          'Ownership transferred successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
