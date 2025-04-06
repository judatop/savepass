import 'package:savepass/app/master_password/domain/entities/update_master_password_entity.dart';
import 'package:savepass/app/master_password/infrastructure/models/update_cards_model.dart';
import 'package:savepass/app/master_password/infrastructure/models/update_passwords_model.dart';

class UpdateMasterPasswordModel extends UpdateMasterPasswordEntity {
  final List<UpdatePasswordsModel> passwordsModel;
  final List<UpdateCardsModel> cardsModel;

  const UpdateMasterPasswordModel({
    required super.oldPassword,
    required super.newPassword,
    required super.nameNewPassword,
    required super.deviceIdParam,
    required super.salt,
    required this.passwordsModel,
    required this.cardsModel,
  }) : super(
          passwords: passwordsModel,
          cards: cardsModel,
        );

  Map<String, dynamic> toJson() {
    return {
      'old_password': oldPassword,
      'new_password': newPassword,
      'name_new_password': nameNewPassword,
      'device_id_param': deviceIdParam,
      'salt_param': salt,
      'passwords': passwordsModel.map((e) => e.toJson()).toList(),
      'cards': cardsModel.map((e) => e.toJson()).toList(),
    };
  }
}
