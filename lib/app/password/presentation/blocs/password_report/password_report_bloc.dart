import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/password/domain/repositories/password_repository.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';
import 'package:savepass/app/password/presentation/blocs/password_report/password_report_event.dart';
import 'package:savepass/app/password/presentation/blocs/password_report/password_report_state.dart';
import 'package:savepass/app/profile/presentation/blocs/profile_bloc.dart';
import 'package:savepass/core/api/savepass_response_model.dart';
import 'package:savepass/core/form/text_form.dart';
import 'package:savepass/core/utils/security_utils.dart';

class PassReportBloc extends Bloc<PassReportEvent, PassReportState> {
  final Logger log;
  final PasswordRepository passwordRepository;

  PassReportBloc({
    required this.log,
    required this.passwordRepository,
  }) : super(const PassReportInitialState()) {
    on<PassReportInitialEvent>(_onPassReportInitialEvent);
    on<ChangeSearchTxtEvent>(_onChangeSearchTxtEvent);
    on<SubmitSearchEvent>(_onSubmitSearchEvent);
  }

  FutureOr<void> _onPassReportInitialEvent(
    PassReportInitialEvent event,
    Emitter<PassReportState> emit,
  ) async {
    emit(
      ChangePassReportState(
        state.model.copyWith(status: FormzSubmissionStatus.inProgress),
      ),
    );

    final profileBloc = Modular.get<ProfileBloc>();
    final derivedKey = profileBloc.state.model.derivedKey;

    if (derivedKey == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    final response = await passwordRepository.getPasswords();
    late final SavePassResponseModel? savePassResponse;
    response.fold(
      (l) {
        savePassResponse = null;
      },
      (r) {
        savePassResponse = r;
      },
    );

    if (savePassResponse == null) {
      emit(
        ChangePassReportState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    List<PasswordModel> passwords = [];

    final data = savePassResponse?.data;

    if (data != null && data['list'] != null) {
      final passwordsList = data['list'] as List;

      passwords.addAll(
        await Future.wait(
          passwordsList.map(
            (e) async {
              final model = PasswordModel.fromJson(e);
              model.copyWith(
                password: await SecurityUtils.decryptPassword(
                  model.password,
                  derivedKey,
                ),
              );

              return PasswordModel.fromJson(e);
            },
          ),
        ),
      );
    }

    emit(
      ChangePassReportState(
        state.model.copyWith(
          status: FormzSubmissionStatus.success,
          passwords: passwords,
        ),
      ),
    );
  }

  FutureOr<void> _onChangeSearchTxtEvent(
    ChangeSearchTxtEvent event,
    Emitter<PassReportState> emit,
  ) {
    emit(
      ChangePassReportState(
        state.model.copyWith(
          searchForm: TextForm.dirty(
            event.searchText,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onSubmitSearchEvent(
    SubmitSearchEvent event,
    Emitter<PassReportState> emit,
  ) async {
    final searchParam = event.search;
    final searchSaved = state.model.searchForm.value;

    final search = searchParam ?? searchSaved;

    if (search.isEmpty) {
      return;
    }

    emit(
      ChangePassReportState(
        state.model.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    final profileBloc = Modular.get<ProfileBloc>();
    final derivedKey = profileBloc.state.model.derivedKey;

    if (derivedKey == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    final response = await passwordRepository.searchPasswords(
      search: search,
    );
    late final SavePassResponseModel? savePassResponse;

    response.fold(
      (l) {
        savePassResponse = null;
      },
      (r) {
        savePassResponse = r;
      },
    );

    if (savePassResponse == null) {
      emit(
        ChangePassReportState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    List<PasswordModel> passwords = [];

    final data = savePassResponse?.data;

    if (data != null && data['list'] != null) {
      final passwordsList = data['list'] as List;

      passwords.addAll(
        await Future.wait(
          passwordsList.map(
            (e) async {
              final model = PasswordModel.fromJson(e);
              model.copyWith(
                password: await SecurityUtils.decryptPassword(
                  model.password,
                  derivedKey,
                ),
              );

              return PasswordModel.fromJson(e);
            },
          ),
        ),
      );
    }

    emit(
      ChangePassReportState(
        state.model.copyWith(
          status: FormzSubmissionStatus.success,
          passwords: passwords,
        ),
      ),
    );
  }
}
