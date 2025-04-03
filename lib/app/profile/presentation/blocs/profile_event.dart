import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class SaveDerivedKeyEvent extends ProfileEvent {
  final Uint8List derivedKey;

  const SaveDerivedKeyEvent({
    required this.derivedKey,
  }) : super();
}

class SaveJwtEvent extends ProfileEvent {
  final String jwt;

  const SaveJwtEvent({
    required this.jwt,
  }) : super();
}

class ClearValuesEvent extends ProfileEvent {
  const ClearValuesEvent() : super();
}
