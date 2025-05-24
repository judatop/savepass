import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  final SplashStateModel model;

  const SplashState(this.model);

  @override
  List<Object> get props => [model];
}

class SplashInitialState extends SplashState {
  const SplashInitialState() : super(const SplashStateModel());
}

class SplashLoadingState extends SplashState {
  const SplashLoadingState(super.model);
}

class OpenGetStartedState extends SplashState {
  const OpenGetStartedState(super.model);
}

class OpenAuthInitState extends SplashState {
  const OpenAuthInitState(super.model);
}

class OpenSyncMasterPasswordState extends SplashState {
  const OpenSyncMasterPasswordState(super.model);
}

class FeatureFlagState extends SplashState {
  const FeatureFlagState(super.model);
}

class SplashStateModel extends Equatable {
  const SplashStateModel();

  @override
  List<Object> get props => [];
}
