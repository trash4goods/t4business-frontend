import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../domain/usecases/interface/profile.dart';
import '../../../domain/entities/profile.dart';
import '../interface/profile.dart';
import '../../presenters/interface/profile.dart';

class ProfileControllerImpl implements ProfileControllerInterface {
  final ProfileUseCaseInterface _useCase;
  final ProfilePresenterInterface _presenter;

  ProfileControllerImpl(this._useCase, this._presenter);

  @override
  Future<void> loadProfile() async {
    try {
      _presenter.setLoading(true);
      _presenter.setError(null);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      
      // Note: When you have access to the real UserProfileModel from the login response,
      // you should call: _presenter.setUserProfile(userProfileFromLoginResponse);
      // instead of the above setProfile call
    } catch (e) {
      log('Error loading profile: $e');
      _presenter.setError('Failed to load profile');
    } finally {
      _presenter.setLoading(false);
    }
  }

  @override
  Future<void> updateName(String name) async {
    _presenter.updateName(name);
  }
  
  @override
  Future<void> updateFirstName(String firstName) async {
    // Update first name in presenter
    // This would be handled when saving the profile
  }
  
  @override
  Future<void> updateLastName(String lastName) async {
    // Update last name in presenter
    // This would be handled when saving the profile
  }
  
  @override
  Future<void> updatePhoneNumber(String phoneNumber) async {
    // Update phone number in presenter
    // This would be handled when saving the profile
  }

  @override
  Future<void> uploadProfilePicture() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        _presenter.setLoading(true);
        final filePath = result.files.single.path!;
        final imageUrl = await _useCase.uploadProfilePicture(filePath);
        _presenter.updateProfilePicture(imageUrl);

        // Save the profile with the new picture
        await saveProfile();

        Get.snackbar(
          'Success',
          'Profile picture updated successfully',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      log('Error uploading profile picture: $e');
      Get.snackbar(
        'Error',
        'Failed to upload profile picture',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _presenter.setLoading(false);
    }
  }

  @override
  Future<void> uploadLogo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        _presenter.setLoading(true);
        final filePath = result.files.single.path!;
        final logoUrl = await _useCase.uploadLogo(filePath);
        _presenter.addLogo(logoUrl);

        // Save the profile with the new logo
        await saveProfile();

        Get.snackbar(
          'Success',
          'Logo uploaded successfully',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      log('Error uploading logo: $e');
      Get.snackbar(
        'Error',
        'Failed to upload logo',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _presenter.setLoading(false);
    }
  }

  @override
  Future<void> deleteLogo(String logoUrl) async {
    try {
      _presenter.setLoading(true);
      final success = await _useCase.deleteLogo(logoUrl);

      if (success) {
        _presenter.removeLogo(logoUrl);

        // Save the profile without the deleted logo
        await saveProfile();

        Get.snackbar(
          'Success',
          'Logo deleted successfully',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete logo',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      log('Error deleting logo: $e');
      Get.snackbar(
        'Error',
        'Failed to delete logo',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _presenter.setLoading(false);
    }
  }

  @override
  Future<void> saveProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

    } catch (e) {
      log('Error saving profile: $e');
      _presenter.setError('Failed to save profile');
      rethrow;
    }
  }

  @override
  Future<void> setMainLogo(String logoUrl) async {
    // Toggle logic: if it's already the main logo, remove it; otherwise set it
    final currentMainLogo = _presenter.mainLogoUrl;
    final newMainLogo = currentMainLogo == logoUrl ? null : logoUrl;

    // Update UI immediately
    _presenter.setMainLogo(newMainLogo);

    try {
      // Save the profile with the updated main logo in the background
      await saveProfile();

      Get.snackbar(
        'Success',
        newMainLogo != null ? 'Logo set as main logo' : 'Main logo removed',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      // If save fails, revert the UI change
      _presenter.setMainLogo(currentMainLogo);
      log('Error setting main logo: $e');
      Get.snackbar(
        'Error',
        'Failed to update main logo',
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
