import 'package:equatable/equatable.dart';
import 'package:savepass/app/password/domain/entities/password_entity.dart';

class PasswordModel extends PasswordEntity with EquatableMixin {
  PasswordModel({
    super.id,
    super.typeImg,
    super.name,
    required super.username,
    required super.password,
    super.vaultId,
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
      vaultId: json['vault_id'],
      description: json['description'],
      domain: json['domain'],
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'type_img_param': typeImg,
      'name_param': name,
      'username_param': username,
      'password_param': password,
      'description_param': description,
      'domain_param': domain,
    };
  }

  Map<String, dynamic> toEditJson() {
    return {
      'type_img_param': typeImg,
      'name_param': name,
      'username_param': username,
      'password_param': password,
      'description_param': description,
      'domain_param': domain,
      'password_id_param': id,
      'vault_id_param': vaultId,
    };
  }

  PasswordModel copyWith({
    String? id,
    String? typeImg,
    String? name,
    String? username,
    String? password,
    String? vaultId,
    String? description,
    String? domain,
  }) {
    return PasswordModel(
      id: id ?? this.id,
      typeImg: typeImg ?? this.typeImg,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      vaultId: vaultId ?? this.vaultId,
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
        vaultId,
        description,
        domain,
      ];
}
