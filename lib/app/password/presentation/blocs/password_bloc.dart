import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/password/presentation/blocs/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password_state.dart';
import 'package:savepass/app/preferences/domain/repositories/preferences_repository.dart';
import 'package:savepass/core/form/password_form.dart';
import 'package:savepass/core/form/text_form.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final Logger log;
  final PreferencesRepository preferencesRepository;

  PasswordBloc({
    required this.log,
    required this.preferencesRepository,
  }) : super(const PasswordInitialState()) {
    on<PasswordInitialEvent>(_onPasswordInitialEvent);
    on<ChangeNameEvent>(_onChangeNameEvent);
    on<ChageEmailEvent>(_onChageEmailEvent);
    on<ChangePasswordEvent>(_onChangePasswordEvent);
    on<ChangeTagEvent>(_onChangeTagEvent);
    on<ChangeDescEvent>(_onChangeDescEvent);
    on<TogglePasswordEvent>(_onTogglePasswordEvent);
  }

  FutureOr<void> _onPasswordInitialEvent(
    PasswordInitialEvent event,
    Emitter<PasswordState> emit,
  ) async {
    emit(
      const ChangePasswordState(
        PasswordStateModel(),
      ),
    );

    final response = await preferencesRepository.getPassImages();

    response.fold(
      (l) {},
      (r) {
        emit(ChangePasswordState(state.model.copyWith(images: r)));
      },
    );
  }

  FutureOr<void> _onChangeNameEvent(
    ChangeNameEvent event,
    Emitter<PasswordState> emit,
  ) {
    emit(
      ChangePasswordState(
        state.model.copyWith(
          name: TextForm.dirty(event.name),
        ),
      ),
    );
  }

  FutureOr<void> _onChageEmailEvent(
    ChageEmailEvent event,
    Emitter<PasswordState> emit,
  ) {
    emit(
      ChangePasswordState(
        state.model.copyWith(
          email: TextForm.dirty(event.email),
        ),
      ),
    );
  }

  FutureOr<void> _onChangePasswordEvent(
    ChangePasswordEvent event,
    Emitter<PasswordState> emit,
  ) {
    emit(
      ChangePasswordState(
        state.model.copyWith(
          password: PasswordForm.dirty(event.password),
        ),
      ),
    );
  }

  FutureOr<void> _onChangeTagEvent(
    ChangeTagEvent event,
    Emitter<PasswordState> emit,
  ) {}

  FutureOr<void> _onChangeDescEvent(
    ChangeDescEvent event,
    Emitter<PasswordState> emit,
  ) {}

  FutureOr<void> _onTogglePasswordEvent(
    TogglePasswordEvent event,
    Emitter<PasswordState> emit,
  ) {
    emit(
      ChangePasswordState(
        state.model.copyWith(
          showPassword: !state.model.showPassword,
        ),
      ),
    );
  }
}
