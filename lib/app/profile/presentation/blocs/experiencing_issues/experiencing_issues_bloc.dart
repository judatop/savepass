import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/preferences/domain/repositories/preferences_repository.dart';
import 'package:savepass/app/profile/presentation/blocs/experiencing_issues/experiencing_issues_event.dart';
import 'package:savepass/app/profile/presentation/blocs/experiencing_issues/experiencing_issues_state.dart';
import 'package:savepass/core/config/routes.dart';

class ExperiencingIssuesBloc
    extends Bloc<ExperiencingIssuesEvent, ExperiencingIssuesState> {
  final Logger log;
  final PreferencesRepository preferencesRepository;

  ExperiencingIssuesBloc({
    required this.log,
    required this.preferencesRepository,
  }) : super(const ExperiencingIssuesInitialState()) {
    on<ExperiencingIssuesInitialEvent>(_onExperiencingIssuesInitialEvent);
  }

  Future<void> _onExperiencingIssuesInitialEvent(
    ExperiencingIssuesInitialEvent event,
    Emitter<ExperiencingIssuesState> emit,
  ) async {
    await _checkFeatureFlag();
  }

  Future<void> _checkFeatureFlag() async {
    bool success = false;
    int maxAttempts = 100;
    int attempts = 0;

    while (!success && attempts < maxAttempts) {
      attempts++;

      final response = await preferencesRepository.getFeatureFlag();

      if (response.isLeft()) {
        await Future.delayed(const Duration(seconds: 5));
        continue;
      }

      final featureFlag = response.getOrElse(() => '');

      if (featureFlag.isEmpty) {
        await Future.delayed(const Duration(seconds: 5));
        continue;
      }

      if (featureFlag == '0') {
        await Future.delayed(const Duration(seconds: 5));
        continue;
      }

      Modular.to.pushNamedAndRemoveUntil(
        Routes.getStartedRoute,
        (_) => false,
      );

      success = true;
    }
  }
}
