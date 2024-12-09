import 'dart:async';
import 'dart:io';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:savepass/app/preferences/domain/repositories/preferences_repository.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/main.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final Logger log;
  final ProfileRepository profileRepository;
  final PreferencesRepository preferencesRepository;

  DashboardBloc({
    required this.log,
    required this.profileRepository,
    required this.preferencesRepository,
  }) : super(const DashboardInitialState()) {
    on<DashboardInitialEvent>(_onDashboardInitialEvent);
    on<ChangeIndexEvent>(_onChangeIndexEvent);
    on<ChangeDisplayNameEvent>(_onChangeDisplayNameEvent);
    on<ChangeAvatarEvent>(_onChangeAvatarEvent);
    on<UploadPhotoEvent>(_onUploadPhotoEvent);
    on<OpenPrivacyPolicyEvent>(_onOpenPrivacyPolicy);
    on<OpenTermsEvent>(_onOpenTermsEvent);
    on<DeleteAccountEvent>(_onDeleteAccountEvent);
    on<LogOutEvent>(_onLogOutEvent);
  }

  FutureOr<void> _onDashboardInitialEvent(
    DashboardInitialEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardInitialState());
    final res = await profileRepository.getProfile();
    res.fold(
      (l) {},
      (r) {
        emit(
          ChangeDashboardState(
            state.model.copyWith(
              profile: r,
              displayName: r.displayName,
            ),
          ),
        );
      },
    );
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
  ) async {
    emit(
      ChangeDashboardState(
        state.model
            .copyWith(displayNameStatus: FormzSubmissionStatus.inProgress),
      ),
    );

    final newDisplayName = event.displayName;

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
              displayName: r.displayName,
            ),
          ),
        );
      },
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
    } catch (error) {
      log.e(error);
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

    response.fold(
      (l) {
        emit(
          GeneralErrorState(
            state.model.copyWith(
              deleteStatus: FormzSubmissionStatus.failure,
            ),
          ),
        );
      },
      (r) async {
        supabase.auth.signOut();
        emit(
          LogOutState(
            state.model.copyWith(
              deleteStatus: FormzSubmissionStatus.success,
            ),
          ),
        );
      },
    );
  }

  FutureOr<void> _onLogOutEvent(
    LogOutEvent event,
    Emitter<DashboardState> emit,
  ) {
    supabase.auth.signOut();
    emit(LogOutState(state.model));
  }
}
