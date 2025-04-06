import 'package:savepass/app/master_password/domain/entities/update_cards_entity.dart';
import 'package:savepass/app/master_password/domain/entities/update_passwords_entity.dart';

class UpdateMasterPasswordEntity {
  final String oldPassword;
  final String newPassword;
  final String nameNewPassword;
  final String deviceIdParam;
  final String salt;
  final List<UpdatePasswordsEntity> passwords; 
  final List<UpdateCardsEntity> cards; 


  const UpdateMasterPasswordEntity({
    required this.oldPassword,
    required this.newPassword,
    required this.nameNewPassword,
    required this.deviceIdParam,
    required this.salt,
    required this.passwords,
    required this.cards,
  });
}
