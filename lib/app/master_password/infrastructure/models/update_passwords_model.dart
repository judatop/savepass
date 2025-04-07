import 'package:savepass/app/master_password/domain/entities/update_passwords_entity.dart';

class UpdatePasswordsModel extends UpdatePasswordsEntity {
  UpdatePasswordsModel({
    required super.id,
    required super.password,
    required super.vaultId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'vault_id': vaultId,
    };
  }
}
