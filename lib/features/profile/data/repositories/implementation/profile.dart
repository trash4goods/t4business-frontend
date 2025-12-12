import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/entities/profile.dart';
import '../../datasources/firebase_profile.dart';
import '../../models/profile.dart';
import '../interface/profile.dart';

class ProfileRepositoryImpl implements ProfileRepositoryInterface {
  final ProfileFirebaseDataSource _dataSource;

  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<ProfileEntity?> getUserProfile(String userId) async {
    try {
      final data = await _dataSource.getUserProfile(userId);
      if (data == null) return null;

      return ProfileModel.fromJson(data).toEntity();
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }

  @override
  Future<bool> updateUserProfile(ProfileEntity profile) async {
    try {
      final model = ProfileModel.fromEntity(profile);
      return await _dataSource.updateUserProfile(model.toJson());
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadProfilePicture(String imagePath) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      return await _dataSource.uploadProfilePicture(imagePath, user.uid);
    } catch (e) {
      throw Exception('Failed to upload profile picture: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadLogo(String imagePath) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      return await _dataSource.uploadLogo(imagePath, user.uid);
    } catch (e) {
      throw Exception('Failed to upload logo: ${e.toString()}');
    }
  }

  @override
  Future<bool> deleteLogo(String logoUrl) async {
    try {
      return await _dataSource.deleteLogo(logoUrl);
    } catch (e) {
      throw Exception('Failed to delete logo: ${e.toString()}');
    }
  }
}
