import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart' as computefoundation;
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:crypto/crypto.dart';

class SecurityUtils {
  static Uint8List deriveMasterKey(
    String masterPassword,
    String salt,
    int keyLength,
  ) {
    final keyDerivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(utf8.encode(salt), 100000, keyLength));

    return keyDerivator.process(utf8.encode(masterPassword));
  }

  static String hashMasterKey(Uint8List derivedKey) {
    return base64Encode(sha256.convert(derivedKey).bytes);
  }

  static String generateSalt(int length) {
    final random = Random.secure();
    final bytes = List<int>.generate(length, (_) => random.nextInt(256));
    return base64Encode(bytes);
  }

  static Future<String> encryptPassword(
    String password,
    Uint8List derivedKey,
  ) async {
    return computefoundation
        .compute(_encryptPasswordComputed, [password, derivedKey]);
  }

  static String _encryptPasswordComputed(List<dynamic> args) {
    final password = args[0] as String;
    final derivedKey = args[1] as Uint8List;

    final key = Key(derivedKey.sublist(0, 32));
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(password, iv: iv);

    return '${base64Encode(iv.bytes)}:${encrypted.base64}';
  }

  static String decryptPassword(String encryptedData, Uint8List derivedKey) {
    final key = Key(derivedKey.sublist(0, 32));

    final parts = encryptedData.split(':');
    final iv = IV.fromBase64(parts[0]);
    final encryptedText = Encrypted.fromBase64(parts[1]);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter.decrypt(encryptedText, iv: iv);
  }
}
