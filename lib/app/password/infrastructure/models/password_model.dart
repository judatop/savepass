import 'package:equatable/equatable.dart';
import 'package:savepass/app/password/domain/entities/password_entity.dart';

class PasswordModel extends PasswordEntity with EquatableMixin {
  PasswordModel({
    super.id,
    super.passImg,
    super.passName,
    required super.passUser,
    required super.passPassword,
    super.passDesc,
    super.passDomain,
  });

  factory PasswordModel.fromJson(Map<String, dynamic> json) {
    return PasswordModel(
      id: json['id'],
      passImg: json['pass_img'],
      passName: json['pass_name'],
      passUser: json['pass_user'],
      passPassword: json['pass_password'],
      passDesc: json['pass_desc'],
      passDomain: json['pass_domain'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'passImg': passImg,
      'passName': passName,
      'passUser': passUser,
      'passPassword': passPassword,
      'passDesc': passDesc,
      'passDomain': passDomain,
    };
  }

  PasswordModel copyWith({
    String? id,
    String? passImg,
    String? passName,
    String? passUser,
    String? passPassword,
    String? passDesc,
    String? passDomain,
  }) {
    return PasswordModel(
      id: id ?? this.id,
      passImg: passImg ?? this.passImg,
      passName: passName ?? this.passName,
      passUser: passUser ?? this.passUser,
      passPassword: passPassword ?? this.passPassword,
      passDesc: passDesc ?? this.passDesc,
      passDomain: passDomain ?? this.passDomain,
    );
  }

  @override
  List<Object?> get props => [
        id,
        passImg,
        passName,
        passUser,
        passPassword,
        passDesc,
        passDomain,
      ];
}
