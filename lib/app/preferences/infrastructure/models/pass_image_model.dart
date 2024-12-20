import 'package:equatable/equatable.dart';
import 'package:savepass/app/preferences/domain/entities/pass_image_entity.dart';

class PassImageModel extends PassImageEntity with EquatableMixin {
  const PassImageModel({
    required super.id,
    required super.key,
    required super.value,
    super.url,
  });

  factory PassImageModel.fromJson(Map<String, dynamic> json) {
    return PassImageModel(
      id: json['id'],
      key: json['key'],
      value: json['value'],
    );
  }

  PassImageModel copyWith({
    String? id,
    String? key,
    String? value,
    String? url,
  }) {
    return PassImageModel(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      url: url ?? this.url,
    );
  }

  @override
  List<Object?> get props => [
        id,
        key,
        value,
        url,
      ];
}
