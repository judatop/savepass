import 'package:savepass/app/master_password/domain/entities/update_master_password_entity.dart';

class UpdateMasterPasswordModel extends UpdateMasterPasswordEntity {
  const UpdateMasterPasswordModel({
    required super.oldPassword,
    required super.newPassword,
    required super.nameNewPassword,
    required super.deviceIdParam,
    required super.salt,
  });

  Map<String, dynamic> toJson() {
    return {
      'old_password': oldPassword,
      'new_password': newPassword,
      'name_new_password': nameNewPassword,
      'device_id_param': deviceIdParam,
      'salt': salt,
    };
  }
}
