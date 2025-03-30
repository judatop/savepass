import 'package:equatable/equatable.dart';

class SavePassResponseModel with EquatableMixin {
  final String code;
  final String? message;
  final Map<String, dynamic>? data;

  const SavePassResponseModel({
    required this.code,
    this.message,
    this.data,
  });

  factory SavePassResponseModel.fromJson(Map<String, dynamic> json) {
    return SavePassResponseModel(
      code: json['code'],
      message: json['message'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data,
    };
  }

  SavePassResponseModel copyWith({
    String? code,
    String? message,
    Map<String, dynamic>? data,
  }) {
    return SavePassResponseModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [
        code,
        message,
        data,
      ];
}
