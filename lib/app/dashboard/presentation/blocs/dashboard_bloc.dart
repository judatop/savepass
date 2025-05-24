import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:savepass/app/auth_init/domain/repositories/auth_init_repository.dart';
import 'package:savepass/app/card/domain/repositories/card_repository.dart';
import 'package:savepass/app/card/infrastructure/models/card_model.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:savepass/app/password/domain/repositories/password_repository.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';
import 'package:savepass/app/preferences/domain/repositories/preferences_repository.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_bloc.dart';
import 'package:savepass/core/api/api_codes.dart';
import 'package:savepass/core/api/savepass_response_model.dart';
import 'package:savepass/core/form/text_form.dart';
import 'package:savepass/core/utils/biometric_utils.dart';
import 'package:savepass/core/utils/device_info.dart';
import 'package:savepass/core/utils/password_utils.dart';
import 'package:savepass/main.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final Logger log;
  final ProfileRepository profileRepository;
  final PreferencesRepository preferencesRepository;
  final PasswordRepository passwordRepository;
  final CardRepository cardRepository;
  final BiometricUtils biometricUtils;
  final FlutterSecureStorage secureStorage;
  final DeviceInfo deviceInfo;
  final AuthInitRepository authInitRepository;

  DashboardBloc({
    required this.log,
    required this.profileRepository,
    required this.preferencesRepository,
    required this.passwordRepository,
    required this.cardRepository,
    required this.biometricUtils,
    required this.secureStorage,
    required this.deviceInfo,
    required this.authInitRepository,
  }) : super(const DashboardInitialState()) {
    on<DashboardInitialEvent>(_onDashboardInitialEvent);
    on<ChangeIndexEvent>(_onChangeIndexEvent);
    on<ChangeDisplayNameEvent>(_onChangeDisplayNameEvent);
    on<SaveDisplayNameEvent>(_onSaveDisplayNameEvent);
    on<ChangeAvatarEvent>(_onChangeAvatarEvent);
    on<UploadPhotoEvent>(_onUploadPhotoEvent);
    on<OpenPrivacyPolicyEvent>(_onOpenPrivacyPolicy);
    on<OpenTermsEvent>(_onOpenTermsEvent);
    on<DeleteAccountEvent>(_onDeleteAccountEvent);
    on<LogOutEvent>(_onLogOutEvent);
    on<OnClickNewPassword>(_onOnClickNewPassword);
    on<CopyPasswordEvent>(_onCopyPasswordEvent);
    on<GetCardValueEvent>(_onGetCardValueEvent);
    on<OnClickNewCard>(_onOnClickNewCard);
    on<OpenSearchEvent>(_onOpenSearchEvent);
    on<CheckBiometricsEvent>(_onCheckBiometricsEvent);
    on<GetProfileEvent>(_onGetProfileEvent);
    on<GetCardsEvent>(_onGetCardsEvent);
    on<GetPasswordsEvent>(_onGetPasswordsEvent);
    on<CheckSupabaseBiometricsEvent>(_onCheckSupabaseBiometricsEvent);
    on<RateItDashboardEvent>(_onRateItDashboardEvent);
    on<SupportDashboardEvent>(_onSupportDashboardEvent);
    on<DocsDashboardEvent>(_onDocsDashboardEvent);
  }

  FutureOr<void> _onDashboardInitialEvent(
    DashboardInitialEvent event,
    Emitter<DashboardState> emit,
  ) {
    final user = supabase.auth.currentUser;
    if (user != null) {
      Sentry.configureScope((scope) {
        scope.setUser(
          SentryUser(
            id: user.id,
            username: user.email,
          ),
        );
      });
    }

    emit(const DashboardInitialState());
  }

  FutureOr<void> _onChangeIndexEvent(
    ChangeIndexEvent event,
    Emitter<DashboardState> emit,
  ) {
    emit(ChangeDashboardState(state.model.copyWith(currentIndex: event.index)));
  }

  FutureOr<void> _onChangeDisplayNameEvent(
    ChangeDisplayNameEvent event,
    Emitter<DashboardState> emit,
  ) {
    final displayName = event.displayName;

    emit(
      ChangeDashboardState(
        state.model.copyWith(displayName: TextForm.dirty(displayName)),
      ),
    );
  }

  FutureOr<void> _onChangeAvatarEvent(
    ChangeAvatarEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      ChangeDashboardState(
        state.model.copyWith(status: FormzSubmissionStatus.inProgress),
      ),
    );

    if (Platform.isIOS) {
      final status = await Permission.photos.status;
      if (status.isGranted) {
        final response = await _uploadPhoto();

        if (response == null) {
          emit(
            ChangeDashboardState(
              state.model.copyWith(status: FormzSubmissionStatus.initial),
            ),
          );
          return;
        }

        if (!response) {
          emit(
            UploadAvatarFailedState(
              state.model.copyWith(status: FormzSubmissionStatus.failure),
            ),
          );
          return;
        }

        final res = await profileRepository.getProfile();

        res.fold(
          (l) {},
          (r) {
            emit(
              ChangeDashboardState(
                state.model.copyWith(
                  profile: r,
                  status: FormzSubmissionStatus.success,
                ),
              ),
            );
          },
        );

        return;
      }

      if (status.isDenied || status.isPermanentlyDenied) {
        emit(
          OpenPhotoPermissionState(
            state.model.copyWith(
              status: FormzSubmissionStatus.failure,
            ),
          ),
        );
        return;
      }
    }

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      PermissionStatus status;
      if (androidInfo.version.sdkInt <= 32) {
        status = await Permission.storage.status;
      } else {
        status = await Permission.photos.status;
      }

      if (status.isGranted) {
        final response = await _uploadPhoto();

        if (response == null) {
          emit(
            ChangeDashboardState(
              state.model.copyWith(status: FormzSubmissionStatus.initial),
            ),
          );
          return;
        }

        if (!response) {
          emit(
            UploadAvatarFailedState(
              state.model.copyWith(status: FormzSubmissionStatus.failure),
            ),
          );
          return;
        }

        final res = await profileRepository.getProfile();

        res.fold(
          (l) {},
          (r) {
            emit(
              ChangeDashboardState(
                state.model.copyWith(
                  profile: r,
                  status: FormzSubmissionStatus.success,
                ),
              ),
            );
          },
        );
        return;
      }

      if (status.isDenied || status.isPermanentlyDenied) {
        emit(
          OpenPhotoPermissionState(
            state.model.copyWith(
              status: FormzSubmissionStatus.failure,
            ),
          ),
        );
        return;
      }
    }
  }

  Future<bool?> _uploadPhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final selectedImg = image.path;

        String? fileUuid;

        final uploadAvatarResponse =
            await profileRepository.uploadAvatar(selectedImg);

        late bool avatarUploaded;
        uploadAvatarResponse.fold(
          (l) {
            avatarUploaded = false;
          },
          (r) async {
            avatarUploaded = true;
            fileUuid = r;
          },
        );

        if (!avatarUploaded) {
          return false;
        }

        final updateProfileResponse =
            await profileRepository.updateProfile(avatarUuid: fileUuid);

        late bool profileUpdated;
        updateProfileResponse.fold(
          (l) {
            profileUpdated = false;
          },
          (r) {
            profileUpdated = true;
          },
        );

        return profileUpdated;
      }

      return null;
    } catch (e, stackTrace) {
      log.severe('uploadPhoto :$e', e, stackTrace);
      return false;
    }
  }

  FutureOr<void> _onUploadPhotoEvent(
    UploadPhotoEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      ChangeDashboardState(
        state.model.copyWith(status: FormzSubmissionStatus.inProgress),
      ),
    );

    final response = await _uploadPhoto();

    if (response == null) {
      emit(
        ChangeDashboardState(
          state.model.copyWith(status: FormzSubmissionStatus.initial),
        ),
      );
      return;
    }

    if (!response) {
      emit(
        UploadAvatarFailedState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    final res = await profileRepository.getProfile();

    res.fold(
      (l) {},
      (r) {
        emit(
          ChangeDashboardState(
            state.model.copyWith(
              profile: r,
              status: FormzSubmissionStatus.success,
            ),
          ),
        );
      },
    );
    return;
  }

  FutureOr<void> _onOpenPrivacyPolicy(
    OpenPrivacyPolicyEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final response = await preferencesRepository.getPrivacyUrl();

    response.fold(
      (l) {
        emit(GeneralErrorState(state.model));
      },
      (r) async {
        final Uri url = Uri.parse(r);

        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          emit(GeneralErrorState(state.model));
        }
      },
    );
  }

  FutureOr<void> _onOpenTermsEvent(
    OpenTermsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final response = await preferencesRepository.getTermsUrl();

    response.fold(
      (l) {
        emit(GeneralErrorState(state.model));
      },
      (r) async {
        final Uri url = Uri.parse(r);

        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          emit(GeneralErrorState(state.model));
        }
      },
    );
  }

  FutureOr<void> _onDeleteAccountEvent(
    DeleteAccountEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      ChangeDashboardState(
        state.model.copyWith(deleteStatus: FormzSubmissionStatus.inProgress),
      ),
    );

    final response = await profileRepository.deleteAccount();

    late SavePassResponseModel? responseModel;
    response.fold(
      (l) {
        responseModel = null;
      },
      (r) {
        responseModel = r;
      },
    );

    if (responseModel == null || responseModel?.code != ApiCodes.success) {
      emit(
        GeneralErrorState(
          state.model.copyWith(
            deleteStatus: FormzSubmissionStatus.failure,
          ),
        ),
      );
      return;
    }

    await secureStorage.deleteAll();
    await profileRepository.deleteAvatar();
    supabase.auth.signOut();
    emit(
      LogOutState(
        state.model.copyWith(
          deleteStatus: FormzSubmissionStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> _onLogOutEvent(
    LogOutEvent event,
    Emitter<DashboardState> emit,
  ) {
    supabase.auth.signOut();
    emit(LogOutState(state.model));
  }

  FutureOr<void> _onSaveDisplayNameEvent(
    SaveDisplayNameEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      ChangeDashboardState(
        state.model
            .copyWith(displayNameStatus: FormzSubmissionStatus.inProgress),
      ),
    );

    final newDisplayName = state.model.displayName.value;

    final updateProfileResponse =
        await profileRepository.updateProfile(displayName: newDisplayName);

    late bool profileUpdated;
    updateProfileResponse.fold(
      (l) {
        profileUpdated = false;
      },
      (r) {
        profileUpdated = true;
      },
    );

    if (!profileUpdated) {
      emit(
        ChangeDashboardState(
          state.model
              .copyWith(displayNameStatus: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    final res = await profileRepository.getProfile();

    res.fold(
      (l) {},
      (r) {
        emit(
          ChangeDashboardState(
            state.model.copyWith(
              profile: r,
              displayNameStatus: FormzSubmissionStatus.success,
            ),
          ),
        );
      },
    );
  }

  FutureOr<void> _onOnClickNewPassword(
    OnClickNewPassword event,
    Emitter<DashboardState> emit,
  ) {
    emit(LoadingDashboardState(state.model));
    emit(OpenPasswordState(state.model));
  }

  FutureOr<void> _onCopyPasswordEvent(
    CopyPasswordEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      ChangeDashboardState(
        state.model.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    String cleanPassword = event.password.password;

    await Clipboard.setData(ClipboardData(text: cleanPassword));

    emit(
      PasswordObtainedState(
        state.model.copyWith(
          status: FormzSubmissionStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> _onGetCardValueEvent(
    GetCardValueEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      ChangeDashboardState(
        state.model.copyWith(
          statusCardValue: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    final derivedKey = Modular.get<ProfileBloc>().state.model.derivedKey;

    if (derivedKey == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(
            deleteStatus: FormzSubmissionStatus.failure,
          ),
        ),
      );
      return;
    }

    final index = event.index;
    final card = event.card.card;

    if (card.isEmpty) {
      return;
    }

    final txt = card.split('|')[index - 1];

    await Clipboard.setData(ClipboardData(text: txt));
    emit(
      CardValueCopiedState(
        state.model.copyWith(
          statusCardValue: FormzSubmissionStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> _onOnClickNewCard(
    OnClickNewCard event,
    Emitter<DashboardState> emit,
  ) {
    emit(LoadingDashboardState(state.model));
    emit(OpenCardState(state.model));
  }

  FutureOr<void> _onOpenSearchEvent(
    OpenSearchEvent event,
    Emitter<DashboardState> emit,
  ) {
    emit(LoadingDashboardState(state.model));
    emit(OpenSearchState(state.model));
  }

  FutureOr<void> _onCheckBiometricsEvent(
    CheckBiometricsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final hasBiometrics = await biometricUtils.hasBiometricsSaved();
    final canAuthenticate =
        await biometricUtils.canAuthenticateWithBiometrics();

    emit(
      ChangeDashboardState(
        state.model.copyWith(
          hasBiometrics: hasBiometrics,
          canAuthenticate: canAuthenticate,
        ),
      ),
    );
  }

  FutureOr<void> _onGetProfileEvent(
    GetProfileEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      ChangeDashboardState(
        state.model.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    final res = await profileRepository.getProfile();
    res.fold(
      (l) {
        GeneralErrorState(
          state.model.copyWith(
            status: FormzSubmissionStatus.failure,
          ),
        );
      },
      (r) {
        emit(
          ChangeDashboardState(
            state.model.copyWith(
              status: FormzSubmissionStatus.success,
              profile: r,
              displayName: TextForm.dirty(r.displayName ?? ''),
            ),
          ),
        );
      },
    );
  }

  FutureOr<void> _onGetCardsEvent(
    GetCardsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      ChangeDashboardState(
        state.model.copyWith(cardStatus: FormzSubmissionStatus.inProgress),
      ),
    );

    final profileBloc = Modular.get<ProfileBloc>();
    final derivedKey = profileBloc.state.model.derivedKey;

    if (derivedKey == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(passwordStatus: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    final cardsRes = await cardRepository.getCards();
    late final SavePassResponseModel? modelResponse;
    cardsRes.fold(
      (l) {
        modelResponse = null;
      },
      (r) {
        modelResponse = r;
      },
    );

    if (modelResponse == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(cardStatus: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    List<CardModel> cards = [];

    final cardsData = modelResponse?.data;

    if (cardsData != null && cardsData['list'] != null) {
      final cardsList = cardsData['list'] as List;

      final decryptedCards =
          await PasswordUtils.getCards(cardsList, derivedKey);

      cards.addAll(decryptedCards);
    }

    emit(
      ChangeDashboardState(
        state.model.copyWith(
          cardStatus: FormzSubmissionStatus.success,
          cards: cards,
        ),
      ),
    );
  }

  FutureOr<void> _onGetPasswordsEvent(
    GetPasswordsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      ChangeDashboardState(
        state.model.copyWith(passwordStatus: FormzSubmissionStatus.inProgress),
      ),
    );

    final profileBloc = Modular.get<ProfileBloc>();
    final derivedKey = profileBloc.state.model.derivedKey;

    if (derivedKey == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(passwordStatus: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    final passwordsResponse = await passwordRepository.getPasswords();
    late final SavePassResponseModel? savePassResponse;
    passwordsResponse.fold(
      (l) {
        savePassResponse = null;
      },
      (r) {
        savePassResponse = r;
      },
    );

    if (savePassResponse == null ||
        savePassResponse?.code != ApiCodes.success) {
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    List<PasswordModel> passwords = [];

    final passwordsData = savePassResponse?.data;

    if (passwordsData != null && passwordsData['list'] != null) {
      final passwordsList = passwordsData['list'] as List;

      final decryptedPasswords =
          await PasswordUtils.getPasswords(passwordsList, derivedKey);

      passwords.addAll(decryptedPasswords);
    }

    emit(
      ChangeDashboardState(
        state.model.copyWith(
          passwordStatus: FormzSubmissionStatus.success,
          passwords: passwords,
        ),
      ),
    );
  }

  FutureOr<void> _onCheckSupabaseBiometricsEvent(
    CheckSupabaseBiometricsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      ChangeDashboardState(
        state.model.copyWith(
          statusBiometrics: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    final deviceId = await deviceInfo.getDeviceId();

    if (deviceId == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(
            statusBiometrics: FormzSubmissionStatus.failure,
          ),
        ),
      );
      return;
    }

    final hasBiometricsSupabaseResponse =
        await authInitRepository.hasBiometrics(deviceId: deviceId);
    late final bool hasSupabaseBiometricsSaved;
    hasBiometricsSupabaseResponse.fold(
      (l) {
        hasSupabaseBiometricsSaved = false;
      },
      (r) {
        hasSupabaseBiometricsSaved = r.data?['hasBiometrics'];
      },
    );

    final hasLocalBiometricsSaved = await biometricUtils.hasBiometricsSaved();
    final canAuthenticate =
        await biometricUtils.canAuthenticateWithBiometrics();

    emit(
      ChangeDashboardState(
        state.model.copyWith(
          hasBiometrics: hasSupabaseBiometricsSaved && hasLocalBiometricsSaved,
          canAuthenticate: canAuthenticate,
          statusBiometrics: FormzSubmissionStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> _onRateItDashboardEvent(
    RateItDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    late Either<Fail<dynamic>, String> response;

    if (Platform.isAndroid) {
      response = await preferencesRepository.getPlayStoreURL();
    } else {
      response = await preferencesRepository.getAppStoreURL();
    }

    late String? url;

    response.fold(
      (l) {
        url = null;
      },
      (r) {
        url = r;
      },
    );

    if (url == null) {
      emit(GeneralErrorState(state.model));
      return;
    }

    final Uri uri = Uri.parse(url!);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      emit(GeneralErrorState(state.model));
    }
  }

  FutureOr<void> _onSupportDashboardEvent(
    SupportDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final response = await preferencesRepository.getSupportMail();

    String? supportMail;

    response.fold(
      (l) {
        supportMail = null;
      },
      (r) {
        supportMail = r;
      },
    );

    if (supportMail == null) {
      emit(GeneralErrorState(state.model));
      return;
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: supportMail,
      queryParameters: {
        'subject': 'Support',
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw Exception('Error launching mail URL');
    }
  }

  FutureOr<void> _onDocsDashboardEvent(
    DocsDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final response = await preferencesRepository.getSavePassDocsURL();

    String? savepassDocsURL;

    response.fold(
      (l) {
        savepassDocsURL = null;
      },
      (r) {
        savepassDocsURL = r;
      },
    );

    if (savepassDocsURL == null) {
      emit(GeneralErrorState(state.model));
      return;
    }

    final Uri uri = Uri.parse(savepassDocsURL!);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      emit(GeneralErrorState(state.model));
    }
  }
}
