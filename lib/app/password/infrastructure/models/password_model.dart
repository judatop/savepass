import 'package:equatable/equatable.dart';
import 'package:savepass/app/password/domain/entities/password_entity.dart';

class PasswordModel extends PasswordEntity with EquatableMixin {
  PasswordModel({
    super.id,
    super.typeImg,
    super.name,
    required super.username,
    required super.password,
    super.description,
    super.domain,
  });

  factory PasswordModel.fromJson(Map<String, dynamic> json) {
    return PasswordModel(
      id: json['id'],
      typeImg: json['type_img'],
      name: json['name'],
      username: json['username'],
      password: json['password'],
      description: json['description'],
      domain: json['domain'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type_img': typeImg,
      'name': name,
      'username': username,
      'password': password,
      'description': description,
      'domain': domain,
    };
  }

  PasswordModel copyWith({
    String? id,
    String? typeImg,
    String? name,
    String? username,
    String? password,
    String? description,
    String? domain,
  }) {
    return PasswordModel(
      id: id ?? this.id,
      typeImg: typeImg ?? this.typeImg,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      description: description ?? this.description,
      domain: domain ?? this.domain,
    );
  }

  @override
  List<Object?> get props => [
        id,
        typeImg,
        name,
        username,
        password,
        description,
        domain,
      ];
}
