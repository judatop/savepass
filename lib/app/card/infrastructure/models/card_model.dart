import 'package:equatable/equatable.dart';
import 'package:savepass/app/card/domain/entities/card_entity.dart';

class CardModel extends CardEntity with EquatableMixin {
  CardModel({
    super.id,
    super.type,
    super.typeId,
    super.imgUrl,
    required super.card,
    super.vaultId,
    super.description,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      type: json['type'],
      typeId: json['type_id'],
      imgUrl: json['imgurl'],
      card: json['card'],
      vaultId: json['vault_id'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'type_param': typeId,
      'card_param': card,
      'description_param': description,
    };
  }

  Map<String, dynamic> toEditJson() {
    return {
      'card_id_param': id,
      'type_param': typeId,
      'card_param': card,
      'vault_id_param': vaultId,
      'description_param': description,
    };
  }

  CardModel copyWith({
    String? id,
    String? type,
    String? typeId,
    String? imgUrl,
    String? card,
    String? vaultId,
    String? description,
  }) {
    return CardModel(
      id: id ?? this.id,
      type: type ?? this.type,
      typeId: typeId ?? this.typeId,
      imgUrl: imgUrl ?? this.imgUrl,
      card: card ?? this.card,
      vaultId: vaultId ?? this.vaultId,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        typeId,
        imgUrl,
        card,
        vaultId,
        description,
      ];
}
