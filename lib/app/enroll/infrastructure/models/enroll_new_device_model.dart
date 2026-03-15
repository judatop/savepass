import 'package:savepass/app/enroll/domain/entities/enroll_new_device_entity.dart';

class EnrollNewDeviceModel extends EnrollNewDeviceEntity {
  const EnrollNewDeviceModel({
    required super.deviceId,
    required super.deviceName,
    required super.type,
    required super.deviceIdToDisable,
  });

  Map<String, dynamic> toJson() {
    return {
      'current_device_id': deviceId,
      'device_name': deviceName,
      'type': type,
      'device_id_to_disable': deviceIdToDisable,
    };
  }

  factory EnrollNewDeviceModel.fromJson(Map<String, dynamic> json) {
    return EnrollNewDeviceModel(
      deviceId: json['device_id'] as String,
      deviceName: json['device_name'] as String,
      type: json['type'] as String,
      deviceIdToDisable: json['device_id_to_disable'] as String,
    );
  }
}
