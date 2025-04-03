import 'package:savepass/app/enroll/domain/entities/enroll_new_device_entity.dart';

class EnrollNewDeviceModel extends EnrollNewDeviceEntity {
  const EnrollNewDeviceModel({
    required super.deviceId,
    required super.deviceName,
    required super.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'device_name': deviceName,
      'type': type,
    };
  }
}
