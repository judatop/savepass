import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/app/sign_up/domain/repositories/sign_up_repository.dart';
import 'package:savepass/app/sign_up/infrastructure/models/sign_up_password_form.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_event.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_state.dart';
import 'package:savepass/core/env/env.dart';
import 'package:savepass/core/form/email_form.dart';
import 'package:savepass/core/form/text_form.dart';
import 'package:savepass/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpRepository signUpRepository;
  final ProfileRepository profileRepository;
  final Logger log;

  SignUpBloc({
    required this.signUpRepository,
    required this.profileRepository,
    required this.log,
  }) : super(const SignUpInitialState()) {
    on<SignUpInitialEvent>(_onSignUpInitial);
    on<NameSignUpChangedEvent>(_onNameSignUpChanged);
    on<OnSubmitFirstStep>(_onOnSubmitFirstStep);
    on<AlreadyHaveAccountEvent>(_onAlreadyHaveAccountEvent);
    on<OpenPrivacyPolicyEvent>(_onOpenPrivacyPolicyEvent);
    on<NameChangedEvent>(_onNameChanged);
    on<EmailChangedEvent>(_onEmailChanged);
    on<PasswordChangedEvent>(_onPasswordChanged);
    on<AvatarChangedEvent>(_onAvatarChanged);
    on<ToggleMasterPasswordEvent>(_onToggleMasterPasswordEvent);
    on<SubmitSignUpFormEvent>(_onSubmitSignUpFormEvent);
    on<SignUpWithGoogleEvent>(_onSignUpWithGoogleEvent);
    on<SignUpWithGithubEvent>(_onSignUpWithGithubEvent);
  }

  FutureOr<void> _onNameSignUpChanged(
    NameSignUpChangedEvent event,
    Emitter<SignUpState> emit,
  ) {
    final name = TextForm.dirty(event.name);
    emit(ChangeSignUpState(state.model.copyWith(name: name)));
  }

  FutureOr<void> _onSignUpInitial(
    SignUpInitialEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(const SignUpInitialState());
  }

  FutureOr<void> _onOnSubmitFirstStep(
    OnSubmitFirstStep event,
    Emitter<SignUpState> emit,
  ) async {
    emit(
      ChangeSignUpState(
        state.model.copyWith(
          alreadySubmitted: true,
        ),
      ),
    );

    if (!Formz.validate([state.model.name])) {
      return;
    }

    emit(OpenSignUpWithEmailState(state.model));
  }

  FutureOr<void> _onAlreadyHaveAccountEvent(
    AlreadyHaveAccountEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(SignUpLoadingState(state.model));
    emit(OpenSignInState(state.model));
  }

  FutureOr<void> _onOpenPrivacyPolicyEvent(
    OpenPrivacyPolicyEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(SignUpLoadingState(state.model));
    emit(OpenPrivacyPolicyState(state.model));
  }

  FutureOr<void> _onNameChanged(
    NameChangedEvent event,
    Emitter<SignUpState> emit,
  ) {
    final name = TextForm.dirty(event.name);
    emit(ChangeSignUpState(state.model.copyWith(name: name)));
  }

  FutureOr<void> _onEmailChanged(
    EmailChangedEvent event,
    Emitter<SignUpState> emit,
  ) {
    final email = EmailForm.dirty(event.email);
    emit(ChangeSignUpState(state.model.copyWith(email: email)));
  }

  FutureOr<void> _onPasswordChanged(
    PasswordChangedEvent event,
    Emitter<SignUpState> emit,
  ) {
    final password = SignUpPasswordForm.dirty(event.password);
    emit(ChangeSignUpState(state.model.copyWith(password: password)));
  }

  FutureOr<void> _onAvatarChanged(
    AvatarChangedEvent event,
    Emitter<SignUpState> emit,
  ) {
    final imagePath = event.imagePath;
    emit(ChangeSignUpState(state.model.copyWith(selectedImg: imagePath)));
  }

  FutureOr<void> _onToggleMasterPasswordEvent(
    ToggleMasterPasswordEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      ChangeSignUpState(
        state.model.copyWith(showPassword: !state.model.showPassword),
      ),
    );
  }

  FutureOr<void> _onSubmitSignUpFormEvent(
    SubmitSignUpFormEvent event,
    Emitter<SignUpState> emit,
  ) async {
    emit(
      ChangeSignUpState(
        state.model.copyWith(
          alreadySubmitted: true,
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    if (!Formz.validate([
      state.model.email,
      state.model.password,
    ])) {
      emit(
        ChangeSignUpState(
          state.model.copyWith(status: FormzSubmissionStatus.initial),
        ),
      );
      return;
    }

    final email = state.model.email.value.toLowerCase();
    final password = state.model.password.value;

    final signUpResponse = await signUpRepository.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user;
    signUpResponse.fold(
      (l) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      },
      (r) async {
        user = r.user;
      },
    );

    if (user == null || user?.id == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    final userId = user!.id;

    final selectedImg = state.model.selectedImg;

    String? fileUuid;
    if (selectedImg != null) {
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
    }

    final createProfileResponse = await profileRepository.createProfile(
      userId: userId,
      displayName: state.model.name.value,
      avatarUuid: fileUuid,
    );

    createProfileResponse.fold(
      (l) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
      },
      (r) {
        emit(
          OpenSyncPassState(
            state.model.copyWith(status: FormzSubmissionStatus.success),
          ),
        );
      },
    );
  }

  FutureOr<void> _onSignUpWithGoogleEvent(
    SignUpWithGoogleEvent event,
    Emitter<SignUpState> emit,
  ) async {
    emit(
      ChangeSignUpState(
        state.model.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    try {
      final webClientId = Env.googleWebClientId;
      final iosClientId = Env.googleIosClientId;

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }
      if (idToken == null) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      final emailExistResponse =
          await profileRepository.isEmailExists(googleUser.email);

      bool? emailExists;

      emailExistResponse.fold(
        (l) {},
        (r) {
          emailExists = r;
        },
      );

      if (emailExists == null) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      if (emailExists!) {
        emit(
          EmailAlreadyInUseState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final user = response.user;

      if (user == null) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      final createProfileResponse = await profileRepository.createProfile(
        userId: user.id,
        displayName: googleUser.displayName,
        avatarUuid: googleUser.photoUrl,
      );

      createProfileResponse.fold(
        (l) {
          emit(
            GeneralErrorState(
              state.model.copyWith(status: FormzSubmissionStatus.failure),
            ),
          );
        },
        (r) {
          emit(
            OpenSyncPassState(
              state.model.copyWith(status: FormzSubmissionStatus.success),
            ),
          );
        },
      );
    } catch (error) {
      log.e('onSignUpWithGoogle error: $error');
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
    }
  }

  FutureOr<void> _onSignUpWithGithubEvent(
    SignUpWithGithubEvent event,
    Emitter<SignUpState> emit,
  ) async {
    //TODO: Implement Github Sign Up
  }
}
