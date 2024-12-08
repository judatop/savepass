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
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final Logger log;
  final ProfileRepository profileRepository;

  DashboardBloc({
    required this.log,
    required this.profileRepository,
  }) : super(const DashboardInitialState()) {
    on<DashboardInitialEvent>(_onDashboardInitialEvent);
    on<ChangeIndexEvent>(_onChangeIndexEvent);
    on<ChangeDisplayNameEvent>(_onChangeDisplayNameEvent);
    on<ChangeAvatarEvent>(_onChangeAvatarEvent);
    on<UploadPhotoEvent>(_onUploadPhotoEvent);
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
}
