import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object> get props => [];
}

class SplashInitialEvent extends SplashEvent {
  const SplashInitialEvent() : super();
}

class ManageRouteChangeEvent extends SplashEvent {
  const ManageRouteChangeEvent() : super();
}
