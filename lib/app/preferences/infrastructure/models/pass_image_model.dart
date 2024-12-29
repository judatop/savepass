import 'package:equatable/equatable.dart';
import 'package:savepass/app/preferences/domain/entities/pass_image_entity.dart';

class PassImageModel extends PassImageEntity with EquatableMixin {
  final bool selected;

  const PassImageModel({
    required super.id,
    required super.key,
    required super.type,
    super.domain,
    this.selected = false,
  });

  factory PassImageModel.fromJson(Map<String, dynamic> json) {
    return PassImageModel(
      id: json['id'],
      key: json['key'],
      type: json['type'],
      domain: json['domain'],
    );
  }

  PassImageModel copyWith({
    String? id,
    String? key,
    String? type,
    String? domain,
    bool? selected,
  }) {
    return PassImageModel(
      id: id ?? this.id,
      key: key ?? this.key,
      type: type ?? this.type,
      domain: domain ?? this.domain,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [
        id,
        key,
        type,
        domain,
        selected,
      ];
}
