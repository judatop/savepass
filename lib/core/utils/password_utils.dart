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
    bool easyToRead = false,
    bool upperLowerCase = true,
    bool numbers = true,
    bool symbols = true,
  }) {
    const String allLetters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String easyLetters =
        'abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ'; // sin l, I, O
    const String allNumbers = '0123456789';
    const String easyNumbers = '23456789'; // sin 0,1
    const String specialChars = '!@#\$%^&*()-_=+[]{}|;:,.<>?';

    String allowedChars = '';

    if (upperLowerCase) {
      allowedChars += easyToRead ? easyLetters : allLetters;
    }

    if (numbers) {
      allowedChars += easyToRead ? easyNumbers : allNumbers;
    }

    if (symbols) {
      allowedChars += specialChars;
    }

    if (allowedChars.isEmpty) {
      throw ArgumentError('Debes permitir al menos un tipo de carácter.');
    }

    final random = Random.secure();
    String password = List.generate(length, (_) {
      return allowedChars[random.nextInt(allowedChars.length)];
    }).join();

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
        final cards = cardsList.map(
          (e) {
            CardModel model = CardModel.fromJson(e);
            model = model.copyWith(
              card: SecurityUtils.decryptPassword(
                model.card,
                derivedKey,
              ),
            );
            return model;
          },
        ).toList();
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
        final passwords = passwordsList.map(
          (e) {
            PasswordModel model = PasswordModel.fromJson(e);
            model = model.copyWith(
              password: SecurityUtils.decryptPassword(
                model.password,
                derivedKey,
              ),
            );

            return model;
          },
        ).toList();
        return passwords;
      },
    );

    return passwords;
  }
}
