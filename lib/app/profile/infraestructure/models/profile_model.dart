import 'package:equatable/equatable.dart';
import 'package:savepass/app/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity with EquatableMixin {
  const ProfileModel({
    super.displayName,
    super.avatar,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      displayName: json['full_name'],
      avatar: json['custom_avatar'] ?? json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'avatar': avatar,
    };
  }

  ProfileModel copyWith({
    String? displayName,
    String? avatar,
  }) {
    return ProfileModel(
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  List<Object?> get props => [
        displayName,
        avatar,
      ];
}
