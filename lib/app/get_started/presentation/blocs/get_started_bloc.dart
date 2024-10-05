import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savepass/app/get_started/presentation/blocs/get_started_event.dart';
import 'package:savepass/app/get_started/presentation/blocs/get_started_state.dart';

class GetStartedBloc extends Bloc<GetStartedEvent, GetStartedState> {
  GetStartedBloc() : super(const GetStartedInitialState()) {
    on<GetStartedInitialEvent>(onGetStartedInitialEvent);
    on<OpenSignInEvent>(onOpenSignInEvent);
    on<OpenSignUpEvent>(onOpenSignUpEvent);
  }

  FutureOr<void> onGetStartedInitialEvent(
    GetStartedInitialEvent event,
    Emitter<GetStartedState> emit,
  ) {}

  FutureOr<void> onOpenSignInEvent(
    OpenSignInEvent event,
    Emitter<GetStartedState> emit,
  ) {
    emit(const GetStartedLoadingState());
    emit(const OpenSignInState());
  }

  FutureOr<void> onOpenSignUpEvent(
    OpenSignUpEvent event,
    Emitter<GetStartedState> emit,
  ) {
    emit(const GetStartedLoadingState());
    emit(const OpenSignUpState());
  }
}
