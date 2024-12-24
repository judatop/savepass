import 'dart:math';

class PasswordUtils {
  static bool atLeast8Characters(String password) {
    return password.length >= 8;
  }

  static bool containsLowerCase(String password) {
    return password.contains(RegExp(r'[a-z]'));
  }

  static bool containsUpperCase(String password) {
    return password.contains(RegExp(r'[A-Z]'));
  }

  static bool containsNumber(String password) {
    return password.contains(RegExp(r'[0-9]'));
  }

  static bool containsSpecialCharacter(String password) {
    return password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
  }

  static bool notContains3RepeatedCharacters(String password) {
    for (int i = 0; i < password.length - 2; i++) {
      if (password[i] == password[i + 1] && password[i] == password[i + 2]) {
        return false;
      }
    }
    return true;
  }

  static bool notContains3ConsecutiveCharacters(String password) {
    for (int i = 0; i < password.length - 2; i++) {
      if (password.codeUnitAt(i) == password.codeUnitAt(i + 1) - 1 &&
          password.codeUnitAt(i) == password.codeUnitAt(i + 2) - 2) {
        return false;
      }
    }
    return true;
  }

  static String generateRandomPassword({
    int length = 16,
    bool includeLetters = true,
    bool includeNumbers = true,
    bool includeSpecialCharacters = true,
  }) {
    const String letters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String numbers = '0123456789';
    const String specialCharacters = '!@#\$%^&*(),.?":{}|<>';

    String allowedChars = '';
    if (includeLetters) allowedChars += letters;
    if (includeNumbers) allowedChars += numbers;
    if (includeSpecialCharacters) allowedChars += specialCharacters;

    if (allowedChars.isEmpty) {
      throw ArgumentError('At least one character set must be included.');
    }

    Random random = Random.secure();
    String password = List.generate(length, (index) {
      return allowedChars[random.nextInt(allowedChars.length)];
    }).join();

     if (!containsLowerCase(password) ||
        !containsUpperCase(password) ||
        !containsNumber(password) ||
        !containsSpecialCharacter(password) ||
        !atLeast8Characters(password) ||
        !notContains3RepeatedCharacters(password) ||
        !notContains3ConsecutiveCharacters(password)) {
      return generateRandomPassword(
        length: length,
        includeLetters: includeLetters,
        includeNumbers: includeNumbers,
        includeSpecialCharacters: includeSpecialCharacters,
      );
    }

    return password;
  }
}
