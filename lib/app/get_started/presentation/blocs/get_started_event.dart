import 'package:equatable/equatable.dart';

abstract class GetStartedEvent extends Equatable {
  const GetStartedEvent();

  @override
  List<Object> get props => [];
}

class OpenSignInEvent extends GetStartedEvent {
  const OpenSignInEvent() : super();
}

class OpenSignUpEvent extends GetStartedEvent {
  const OpenSignUpEvent() : super();
}

class GetStartedInitialEvent extends GetStartedEvent {
  const GetStartedInitialEvent() : super();
}

class GetStartedLoadingEvent extends GetStartedEvent {
  const GetStartedLoadingEvent() : super();
}
