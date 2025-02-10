import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/password/domain/repositories/password_repository.dart';
import 'package:savepass/app/password/presentation/blocs/password_report/password_report_event.dart';
import 'package:savepass/app/password/presentation/blocs/password_report/password_report_state.dart';
import 'package:savepass/core/form/text_form.dart';

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

    final response = await passwordRepository.getPasswords();

    response.fold(
      (l) {
        emit(
          ChangePassReportState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
      },
      (r) {
        emit(
          ChangePassReportState(
            state.model.copyWith(
              status: FormzSubmissionStatus.success,
              passwords: r,
            ),
          ),
        );
      },
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

    final response = await passwordRepository.searchPasswords(search);

    response.fold(
      (l) {
        emit(
          GeneralErrorState(
            state.model.copyWith(
              status: FormzSubmissionStatus.failure,
            ),
          ),
        );
      },
      (r) {
        emit(
          ChangePassReportState(
            state.model.copyWith(
              status: FormzSubmissionStatus.success,
              passwords: r,
            ),
          ),
        );
      },
    );
  }
}
