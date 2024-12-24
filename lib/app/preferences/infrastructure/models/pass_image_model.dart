import 'package:equatable/equatable.dart';
import 'package:savepass/app/preferences/domain/entities/pass_image_entity.dart';

class PassImageModel extends PassImageEntity with EquatableMixin {
  final bool selected;

  const PassImageModel({
    required super.id,
    required super.key,
    required super.value,
    this.selected = false,
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
    bool? selected,
  }) {
    return PassImageModel(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [
        id,
        key,
        value,
        selected,
      ];
}
