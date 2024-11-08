import 'package:equatable/equatable.dart';
import 'package:savepass/app/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity with EquatableMixin {
  const ProfileModel({
    super.displayName,
    super.avatar,
    super.masterPasswordUuid,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      displayName: json['display_name'],
      avatar: json['avatar_uuid'],
      masterPasswordUuid: json['master_password_uuid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'avatar': avatar,
      'masterPasswordUuid': masterPasswordUuid,
    };
  }

  ProfileModel copyWith({
    String? displayName,
    String? avatar,
    String? masterPasswordUuid,
  }) {
    return ProfileModel(
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
      masterPasswordUuid: masterPasswordUuid ?? this.masterPasswordUuid,
    );
  }

  @override
  List<Object?> get props => [
        displayName,
        avatar,
        masterPasswordUuid,
      ];
}
