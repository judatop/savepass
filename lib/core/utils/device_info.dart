import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

class DeviceInfo {
  final Logger log;
  final MethodChannel _channel =
      const MethodChannel('com.juda.savepass/device_info');

  const DeviceInfo({required this.log});

  Future<String?> _getAndroidId() async {
    try {
      final String? androidId = await _channel.invokeMethod('getAndroidId');
      return androidId;
    } on PlatformException catch (e, stackTrace) {
      log.severe('Error getting Android ID: ${e.message}', e, stackTrace);
      return null;
    }
  }

  Future<String?> _getIosId() async {
    try {
      final String? identifier =
          await _channel.invokeMethod('getIosIdentifierForVendor');
      return identifier;
    } on PlatformException catch (e, stackTrace) {
      log.severe('Error getting iOS ID: ${e.message}', e, stackTrace);
      return null;
    }
  }

  Future<String?> getDeviceId() async {
    if (Platform.isAndroid) {
      return await _getAndroidId();
    } else {
      return await _getIosId();
    }
  }

  Future<String> getDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      return (await deviceInfo.androidInfo).model;
    } else {
      return (await deviceInfo.iosInfo).utsname.machine;
    }
  }

  String getDeviceType() {
    return Platform.isAndroid ? 'Android' : 'iOS';
  }
}
