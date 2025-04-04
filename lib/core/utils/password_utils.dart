import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:savepass/app/card/infrastructure/models/card_model.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';
import 'package:savepass/core/utils/security_utils.dart';

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

  static String formatCard(String card) {
    if (card.length != 16) {
      return card;
    }
    return '${card.substring(0, 4)} XXXX XXXX ${card.substring(12, 16)}';
  }

  static Future<List<CardModel>> getCards(
    List<dynamic> cardsList,
    Uint8List derivedKey,
  ) async {
    final List<CardModel> cards = await Isolate.run<List<CardModel>>(
      () async {
        final cards = await Future.wait(
          cardsList.map(
            (e) async {
              CardModel model = CardModel.fromJson(e);
              model = model.copyWith(
                card: SecurityUtils.decryptPassword(model.card, derivedKey),
              );
              return model;
            },
          ),
        );
        return cards;
      },
    );

    return cards;
  }

  static Future<List<PasswordModel>> getPasswords(
    List<dynamic> passwordsList,
    Uint8List derivedKey,
  ) async {
    final List<PasswordModel> passwords =
        await Isolate.run<List<PasswordModel>>(
      () async {
        final passwords = await Future.wait(
          passwordsList.map(
            (e) async {
              final model = PasswordModel.fromJson(e);
              model.copyWith(
                password: SecurityUtils.decryptPassword(
                  model.password,
                  derivedKey,
                ),
              );

              return PasswordModel.fromJson(e);
            },
          ),
        );
        return passwords;
      },
    );

    return passwords;
  }
}
