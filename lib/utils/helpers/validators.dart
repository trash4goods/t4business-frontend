// filepath: /Users/marcelocesar/Desktop/t4g_dashboard/lib/src/utils/validators.dart
import 'package:get/get.dart';

/// A utility class for form input validation
class ValidatorsHelper {
  ValidatorsHelper._(); // Private constructor to prevent instantiation

  /// Validates an email address
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates a password (at least 6 characters)
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validates a password with more strict requirements
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  /// Validates required fields
  static String? required(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates minimum length
  static String? minLength(
    String? value,
    int length, {
    String fieldName = 'Field',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (value.length < length) {
      return '$fieldName must be at least $length characters';
    }
    return null;
  }

  /// Validates that two values match
  static String? match(
    String? value,
    String? matchValue, {
    String fieldName = 'Field',
    String matchFieldName = 'Match Field',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (value != matchValue) {
      return '$fieldName must match $matchFieldName';
    }
    return null;
  }

  /// Validates a phone number
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!GetUtils.isPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}
