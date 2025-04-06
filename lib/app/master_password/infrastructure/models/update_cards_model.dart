import 'package:savepass/app/master_password/domain/entities/update_cards_entity.dart';

class UpdateCardsModel extends UpdateCardsEntity {
  UpdateCardsModel({
    required super.id,
    required super.card,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card': card,
    };
  }
}
