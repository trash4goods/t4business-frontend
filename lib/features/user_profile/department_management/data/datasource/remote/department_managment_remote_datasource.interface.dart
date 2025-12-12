import 'package:t4g_for_business/features/user_profile/department_management/data/models/team.dart';

import '../../models/manage_team.dart';

abstract class DepartmentManagmentRemoteDatasourceInterface {
  Future<void> inviteToDepartment(List<String> emails, String token);
  Future<List<ManageTeamModel>> getDepartmentTeam(String token);
  Future<void> leaveDepartment(String token);
  Future<void> transferOwnership(String token, int newOwnerUserId);
  Future<void> manageTeam(String token, TeamModel? team);
}
