import 'dart:async';
import 'dart:io';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:savepass/app/dashboard/infrastructure/models/display_name_form.dart';
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
  ) {
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
    emit(
      ChangeDashboardState(
        state.model.copyWith(
          displayName: DisplayNameForm.dirty(event.displayName),
        ),
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
        _uploadPhoto(emit);
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
        _uploadPhoto(emit);
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

  void _uploadPhoto(
    Emitter<DashboardState> emit,
  ) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final selectedImg = image.path;

        String? fileUuid;

        final uploadAvatarResponse =
            await profileRepository.uploadAvatar(selectedImg);

        uploadAvatarResponse.fold(
          (l) {
            emit(
              GeneralErrorState(
                state.model.copyWith(status: FormzSubmissionStatus.failure),
              ),
            );
          },
          (r) async {
            fileUuid = r;
          },
        );

        final updateProfileResponse =
            await profileRepository.updateProfile(avatarUuid: fileUuid);

        updateProfileResponse.fold(
          (l) {
            emit(
              GeneralErrorState(
                state.model.copyWith(status: FormzSubmissionStatus.failure),
              ),
            );
          },
          (r) {},
        );

        emit(
          ChangeDashboardState(
            state.model.copyWith(status: FormzSubmissionStatus.success),
          ),
        );
      }
    } catch (error) {
      log.e(error);
      emit(
        ChangeDashboardState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
    }
  }

  FutureOr<void> _onUploadPhotoEvent(
    UploadPhotoEvent event,
    Emitter<DashboardState> emit,
  ) {
    emit(
      ChangeDashboardState(
        state.model.copyWith(status: FormzSubmissionStatus.inProgress),
      ),
    );
    _uploadPhoto(emit);
  }
}
