import 'dart:ui';

class ProfileChangeSettingsUtils {
  static Color getStrengthColor(double strength) {
    if (strength < 0.25) return const Color(0xFFDC2626); // Red - Very Weak
    if (strength < 0.5) return const Color(0xFFEA580C); // Orange - Weak
    if (strength < 0.75) return const Color(0xFFCA8A04); // Yellow - Fair
    if (strength < 0.9) return const Color(0xFF16A34A); // Green - Good
    return const Color(0xFF059669); // Dark Green - Strong
  }

  static String getStrengthText(double strength) {
    if (strength < 0.25) return 'Very Weak';
    if (strength < 0.5) return 'Weak';
    if (strength < 0.75) return 'Fair';
    if (strength < 0.9) return 'Good';
    return 'Strong';
  }

  static String getPasswordRequirements(String password) {
    final List<String> missing = [];

    if (password.length < 8) {
      missing.add('8+ characters');
    }
    if (password.length < 12) {
      missing.add('12+ chars recommended');
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      missing.add('lowercase letter');
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      missing.add('uppercase letter');
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      missing.add('number');
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      missing.add('special character');
    }

    if (missing.isEmpty) {
      return '✓ Password meets all security requirements';
    }

    return 'Missing: ${missing.join(', ')}';
  }

  static bool hasSequentialCharacters(String password) {
    final sequences = [
      '123',
      '234',
      '345',
      '456',
      '567',
      '678',
      '789',
      '890',
      'abc',
      'bcd',
      'cde',
      'def',
      'efg',
      'fgh',
      'ghi',
      'hij',
      'ijk',
      'jkl',
      'klm',
      'lmn',
      'mno',
      'nop',
      'opq',
      'pqr',
      'qrs',
      'rst',
      'stu',
      'tuv',
      'uvw',
      'vwx',
      'wxy',
      'xyz',
    ];

    final lowerPassword = password.toLowerCase();
    return sequences.any(
      (seq) =>
          lowerPassword.contains(seq) ||
          lowerPassword.contains(seq.split('').reversed.join()),
    );
  }

    static bool isCommonPassword(String password) {
    final commonPasswords = [
      'password',
      'password123',
      '123456',
      '123456789',
      'qwerty',
      'abc123',
      'password1',
      'admin',
      'letmein',
      'welcome',
      'monkey',
      '1234567890',
      'dragon',
      'master',
      'hello',
      'login',
      'pass',
      'admin123',
      'root',
      'user',
      'test',
      'guest',
      'info',
      'administrator',
      'changeme',
      'newpassword',
    ];

    final lowerPassword = password.toLowerCase();
    return commonPasswords.any(
      (common) =>
          lowerPassword.contains(common) || common.contains(lowerPassword),
    );
  }

  static bool hasMultipleCharacterTypes(String password) {
    int types = 0;
    if (password.contains(RegExp(r'[a-z]'))) types++;
    if (password.contains(RegExp(r'[A-Z]'))) types++;
    if (password.contains(RegExp(r'[0-9]'))) types++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) types++;
    return types >= 3;
  }

  static   double calculatePasswordStrength(String password) {
    double strength = 0.0;

    // Length scoring (more granular)
    if (password.length >= 8) strength += 0.15;
    if (password.length >= 12) strength += 0.15;
    if (password.length >= 16) strength += 0.1;

    // Character variety checks
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.15;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.15;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.15;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.15;

    // Bonus points for complexity
    if (hasMultipleCharacterTypes(password)) strength += 0.05;
    if (password.length >= 20) strength += 0.05;

    // Penalties for common patterns
    if (hasSequentialCharacters(password)) strength -= 0.2;
    if (hasTooManyRepeatedCharacters(password)) strength -= 0.2;
    if (isCommonPassword(password)) strength -= 0.3;

    return strength.clamp(0.0, 1.0);
  }

  static bool hasTooManyRepeatedCharacters(String password) {
    if (password.length < 3) return false;

    for (int i = 0; i <= password.length - 3; i++) {
      final char = password[i];
      if (password[i + 1] == char && password[i + 2] == char) {
        return true; // Three consecutive identical characters
      }
    }

    // Check for patterns like "aaa", "111", etc.
    final charCounts = <String, int>{};
    for (final char in password.split('')) {
      charCounts[char] = (charCounts[char] ?? 0) + 1;
    }

    // If any character appears more than 25% of the password length
    final maxAllowed = (password.length * 0.25).ceil();
    return charCounts.values.any((count) => count > maxAllowed);
  }
}
