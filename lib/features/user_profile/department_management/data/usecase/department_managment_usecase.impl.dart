import 'dart:developer';

import '../models/manage_team.dart';
import '../models/team.dart';
import '../repository/department_managment_repository.interface.dart';
import 'department_managment_usecase.interface.dart';

/// Implementation of department management use case
/// Handles business logic for team member operations using ManageTeamModel
class DepartmentManagmentUseCaseImpl
    implements DepartmentManagmentUseCaseInterface {
  final DepartmentManagmentRepositoryInterface repository;

  DepartmentManagmentUseCaseImpl(this.repository);

  @override
  Future<void> inviteToDepartment(List<String> emails, String token) async {
    try {
      // Validate input parameters
      if (emails.isEmpty) {
        throw ArgumentError('Email list cannot be empty');
      }

      if (token.isEmpty) {
        throw ArgumentError('Token cannot be empty');
      }

      // Validate email formats
      for (final email in emails) {
        if (!_isValidEmail(email)) {
          throw ArgumentError('Invalid email format: $email');
        }
      }

      await repository.inviteToDepartment(emails, token);
    } catch (e) {
      // Add context to the error for better debugging
      throw Exception('Failed to invite users to department: ${e.toString()}');
    }
  }

  @override
  Future<List<ManageTeamModel>> getDepartmentTeam(String token) async {
    try {
      if (token.isEmpty) {
        throw ArgumentError('Token cannot be empty');
      }

      final teamMembers = await repository.getDepartmentTeam(token);

      // Filter out any null or invalid team members
      return teamMembers
          .where((member) => member.userId != null)
          .toList();
    } catch (e) {
      throw Exception('Failed to get department team: ${e.toString()}');
    }
  }

  @override
  Future<void> leaveDepartment(String token) async {
    try {
      if (token.isEmpty) {
        throw ArgumentError('Token cannot be empty');
      }

      await repository.leaveDepartment(token);
    } catch (e) {
      throw Exception('Failed to leave department: ${e.toString()}');
    }
  }

  @override
  Future<void> transferOwnership(String token, int newOwnerUserId) async {
    try {
      if (token.isEmpty) {
        throw ArgumentError('Token cannot be empty');
      }

      // Validate that the new owner exists in the team
      final teamMembers = await repository.getDepartmentTeam(token);
      final newOwner = teamMembers.firstWhere(
        (member) => member.userId == newOwnerUserId,
        orElse: () => throw ArgumentError('New owner not found in team'),
      );

      // Validate that the new owner is not already an admin
      if (newOwner.roleName == 't4b_admin' || newOwner.roleName == 'admin') {
        throw ArgumentError('User is already an admin');
      }

      await repository.transferOwnership(token, newOwnerUserId);
      log('Ownership transferred successfully');
    } catch (e) {
      throw Exception('Failed to transfer ownership: ${e.toString()}');
    }
  }

  @override
  Future<void> manageTeam(String token, TeamModel? team) async {
    try {
      if (token.isEmpty) {
        throw ArgumentError('Token cannot be empty');
      }

      if (team == null || team.team == null || team.team!.isEmpty) {
        throw ArgumentError('Team data cannot be null or empty');
      }

      // Validate team member data
      for (final member in team.team!) {
        if (member.userId == null) {
          throw ArgumentError('Team member userId cannot be null or empty');
        }

        if (member.roleName == null || member.roleName!.isEmpty) {
          throw ArgumentError('Team member roleName cannot be null or empty');
        }

        // Validate role names
        final validRoles = ['member', 'admin', 't4b_admin', 'pending'];
        if (!validRoles.contains(member.roleName)) {
          throw ArgumentError('Invalid role name: ${member.roleName}');
        }
      }

      await repository.manageTeam(token, team);
    } catch (e) {
      throw Exception('Failed to manage team: ${e.toString()}');
    }
  }

  /// Validates email format using a simple regex pattern
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }
}
