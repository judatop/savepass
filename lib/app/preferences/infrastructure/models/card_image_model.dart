import 'package:equatable/equatable.dart';
import 'package:savepass/app/preferences/domain/entities/card_image_entity.dart';

class CardImageModel extends CardImageEntity with EquatableMixin {
  const CardImageModel({
    required super.id,
    required super.type,
    required super.imgUrl,
  });

  factory CardImageModel.fromJson(Map<String, dynamic> json) {
    return CardImageModel(
      id: json['id'],
      type: json['type'],
      imgUrl: json['imgurl'],
    );
  }

  CardImageModel copyWith({
    String? id,
    String? type,
    String? imgUrl,
  }) {
    return CardImageModel(
      id: id ?? this.id,
      type: type ?? this.type,
      imgUrl: imgUrl ?? this.imgUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        imgUrl,
      ];
}
