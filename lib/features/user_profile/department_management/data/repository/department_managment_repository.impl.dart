import '../datasource/remote/department_managment_remote_datasource.interface.dart';
import '../models/manage_team.dart';
import '../models/team.dart';
import 'department_managment_repository.interface.dart';

class DepartmentManagmentRepositoryImpl
    implements DepartmentManagmentRepositoryInterface {
  final DepartmentManagmentRemoteDatasourceInterface remoteDatasource;

  DepartmentManagmentRepositoryImpl(this.remoteDatasource);

  @override
  Future<void> inviteToDepartment(List<String> emails, String token) async {
    try {
      await remoteDatasource.inviteToDepartment(emails, token);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ManageTeamModel>> getDepartmentTeam(String token) async {
    try {
      return await remoteDatasource.getDepartmentTeam(token);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> leaveDepartment(String token) async {
    try {
      await remoteDatasource.leaveDepartment(token);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> transferOwnership(String token, int newOwnerUserId) async {
    try {
      await remoteDatasource.transferOwnership(token, newOwnerUserId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> manageTeam(String token, TeamModel? team) async {
    try {
      await remoteDatasource.manageTeam(token, team);
    } catch (e) {
      rethrow;
    }
  }
}
