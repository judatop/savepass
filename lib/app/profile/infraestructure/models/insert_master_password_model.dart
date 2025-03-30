import 'package:savepass/app/profile/domain/entities/insert_master_password_entity.dart';

class InsertMasterPasswordModel extends InsertMasterPasswordEntity {
  const InsertMasterPasswordModel({
    required super.secret,
    required super.name,
    required super.deviceId,
    required super.deviceName,
    required super.type,
    required super.salt,
  });

  Map<String, dynamic> toJson() {
    return {
      'secret': secret,
      'name': name,
      'device_id': deviceId,
      'device_name': deviceName,
      'type': type,
      'salt': salt,
    };
  }
}
