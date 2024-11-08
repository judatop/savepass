import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/app/splash/presentation/blocs/splash_event.dart';
import 'package:savepass/app/splash/presentation/blocs/splash_state.dart';
import 'package:savepass/main.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final ProfileRepository profileRepository;

  SplashBloc({required this.profileRepository})
      : super(const SplashInitialState()) {
    on<SplashInitialEvent>(_onSplashInitial);
    on<ManageRouteChangeEvent>(_onManageRouteChangeEvent);
  }

  FutureOr<void> _onSplashInitial(
    SplashInitialEvent event,
    Emitter<SplashState> emit,
  ) {
    emit(const SplashInitialState());
  }

  FutureOr<void> _onManageRouteChangeEvent(
    ManageRouteChangeEvent event,
    Emitter<SplashState> emit,
  ) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      emit(OpenGetStartedState(state.model));
      return;
    }

    final response = await profileRepository.checkIfHasMasterPassword();

    bool hasMasterPassword = false;

    response.fold(
      (l) {
        hasMasterPassword = false;
      },
      (r) {
        hasMasterPassword = r;
      },
    );

    if (!hasMasterPassword) {
      emit(OpenSyncMasterPasswordState(state.model));
      return;
    }

    emit(OpenAuthInitState(state.model));
  }
}
