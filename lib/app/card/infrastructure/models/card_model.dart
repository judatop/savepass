import 'package:equatable/equatable.dart';
import 'package:savepass/app/card/domain/entities/card_entity.dart';

class CardModel extends CardEntity with EquatableMixin {
  CardModel({
    super.id,
    super.type,
    required super.card,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      type: json['type'],
      card: json['card'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'card': card,
    };
  }

  CardModel copyWith({
    String? id,
    String? type,
    String? card,
  }) {
    return CardModel(
      id: id ?? this.id,
      type: type ?? this.type,
      card: card ?? this.card,
    );
  }

  @override
  List<Object?> get props => [id, type, card];
}
