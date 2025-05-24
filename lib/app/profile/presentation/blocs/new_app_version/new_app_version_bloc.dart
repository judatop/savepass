import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/preferences/domain/repositories/preferences_repository.dart';
import 'package:savepass/app/profile/presentation/blocs/new_app_version/new_app_version_event.dart';
import 'package:savepass/app/profile/presentation/blocs/new_app_version/new_app_version_state.dart';
import 'package:url_launcher/url_launcher.dart';

class NewAppVersionBloc
    extends Bloc<NewAppVersionEvent, NewAppVersionState> {
  final Logger log;
  final PreferencesRepository preferencesRepository;

  NewAppVersionBloc({
    required this.log,
    required this.preferencesRepository,
  }) : super(const NewAppVersionInitialState()) {
    on<DownloadNewVersionEvent>(_onDownloadNewVersionEvent);
  }

  FutureOr<void> _onDownloadNewVersionEvent(
    DownloadNewVersionEvent event,
    Emitter<NewAppVersionState> emit,
  ) async {
    late Either<Fail<dynamic>, String> response;

    if (Platform.isAndroid) {
      response = await preferencesRepository.getPlayStoreURL();
    } else {
      response = await preferencesRepository.getAppStoreURL();
    }

    response.fold(
      (l) {
        emit(const GeneralErrorState());
      },
      (r) async {
        final Uri url = Uri.parse(r);

        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          emit(const GeneralErrorState());
        }
      },
    );
  }
}
