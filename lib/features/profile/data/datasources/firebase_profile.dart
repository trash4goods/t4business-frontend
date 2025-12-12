import 'dart:developer';
import 'package:flutter/foundation.dart';

class ProfileFirebaseDataSource {
  // Mock implementation for Firebase services
  // In a real app, you would use the actual Firebase packages

  // Mock storage for profile data (simulates Firestore)
  static final Map<String, Map<String, dynamic>> _mockProfiles = {};

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      // Mock implementation - in real app would use Firestore
      await Future.delayed(const Duration(milliseconds: 500));

      // Check if we have saved data for this user
      if (_mockProfiles.containsKey(userId)) {
        log('Returning saved profile for user: $userId');
        return _mockProfiles[userId];
      }

      // Return default Coca-Cola profile data for new users
      // In a real app, this would query Firestore and return actual user data
      final defaultProfile = {
        'userId': userId,
        'email': 'admin@cocacola.com',
        'name': 'Coca cola Admin',
        'profilePictureUrl': 'assets/images/Coca-Cola-Logo01.png',
        'logoUrls': [
          'assets/images/Coca-Cola-Logo01.png',
          'assets/images/coca-cola-logo02.jpeg',
          'assets/images/coca-cola-logo03.jpg',
        ],
        'mainLogoUrl': 'assets/images/Coca-Cola-Logo01.png',
      };

      // Save the default profile for this user
      _mockProfiles[userId] = defaultProfile;
      log('Created default profile for user: $userId');
      return defaultProfile;
    } catch (e) {
      log('Error getting user profile: $e');
      throw Exception('Failed to get user profile');
    }
  }

  Future<bool> updateUserProfile(Map<String, dynamic> profileData) async {
    try {
      // Mock implementation - in real app would use Firestore
      await Future.delayed(const Duration(milliseconds: 500));

      // Save the profile data to our mock storage
      final userId = profileData['userId'] as String;
      _mockProfiles[userId] = Map<String, dynamic>.from(profileData);

      log('Profile updated and saved for user $userId: $profileData');
      return true;
    } catch (e) {
      log('Error updating user profile: $e');
      return false;
    }
  }

  Future<String> uploadProfilePicture(String imagePath, String userId) async {
    try {
      // Mock implementation - in real app would use Firebase Storage
      await Future.delayed(const Duration(milliseconds: 1000));

      if (kIsWeb) {
        // For web, return the blob URL as-is for now
        return imagePath.startsWith('blob:')
            ? imagePath
            : 'https://picsum.photos/400/400?random=${DateTime.now().millisecondsSinceEpoch}';
      } else {
        // For mobile/desktop, return a mock URL
        return 'https://picsum.photos/400/400?random=${DateTime.now().millisecondsSinceEpoch}';
      }
    } catch (e) {
      log('Error uploading profile picture: $e');
      throw Exception('Failed to upload profile picture');
    }
  }

  Future<String> uploadLogo(String imagePath, String userId) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      // Mock implementation - in real app would use Firebase Storage
      await Future.delayed(const Duration(milliseconds: 1000));

      if (kIsWeb) {
        // For web, return the blob URL as-is for now
        return imagePath.startsWith('blob:')
            ? imagePath
            : 'https://picsum.photos/300/200?random=$timestamp';
      } else {
        // For mobile/desktop, return a mock URL
        return 'https://picsum.photos/300/200?random=$timestamp';
      }
    } catch (e) {
      log('Error uploading logo: $e');
      throw Exception('Failed to upload logo');
    }
  }

  Future<bool> deleteLogo(String logoUrl) async {
    try {
      // Mock implementation - in real app would delete from Firebase Storage
      await Future.delayed(const Duration(milliseconds: 500));
      log('Logo deleted: $logoUrl');
      return true;
    } catch (e) {
      log('Error deleting logo: $e');
      return false;
    }
  }
}
