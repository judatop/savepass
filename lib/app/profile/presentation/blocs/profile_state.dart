import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  final ProfileStateModel model;

  const ProfileState(this.model);

  @override
  List<Object?> get props => [model];
}

class ProfileInitialState extends ProfileState {
  const ProfileInitialState() : super(const ProfileStateModel());
}

class ChangeProfileState extends ProfileState {
  const ChangeProfileState(super.model);
}

class ProfileStateModel extends Equatable {
  final Uint8List? derivedKey;
  final String? jwt;

  const ProfileStateModel({
    this.derivedKey,
    this.jwt,
  });

  ProfileStateModel copyWith({
    Uint8List? derivedKey,
    String? jwt,
  }) {
    return ProfileStateModel(
      derivedKey: derivedKey ?? this.derivedKey,
      jwt: jwt ?? this.jwt,
    );
  }

  @override
  List<Object?> get props => [
        derivedKey,
        jwt,
      ];
}
