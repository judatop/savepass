
import 'package:equatable/equatable.dart';

abstract class GetStartedState extends Equatable {

  const GetStartedState();

  @override
  List<Object> get props => [];
}

class GetStartedInitialState extends GetStartedState {
  const GetStartedInitialState() : super();
}

class GetStartedLoadingState extends GetStartedState {
  const GetStartedLoadingState();
}

class OpenSignInState extends GetStartedState {
  const OpenSignInState() : super();
}

class OpenSignUpState extends GetStartedState {
  const OpenSignUpState() : super();
}