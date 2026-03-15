import 'package:savepass/app/enroll/domain/entities/device_entity.dart';

class DeviceModel extends DeviceEntity {
  const DeviceModel({
    required super.id,
    required super.deviceId,
    required super.deviceName,
    required super.type,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] as String,
      deviceId: json['device_id'] as String,
      deviceName: json['device_name'] as String,
      type: json['type'] as String,
    );
  }
}
