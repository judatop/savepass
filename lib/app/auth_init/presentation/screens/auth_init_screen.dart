import 'dart:io';

import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:lottie/lottie.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_bloc.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_event.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_state.dart';
import 'package:savepass/app/auth_init/presentation/widgets/master_password_widget.dart';
import 'package:savepass/app/auth_init/presentation/widgets/submit_button_widget.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/lottie/lottie_paths.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:savepass/main.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AuthInitScreen extends StatelessWidget {
  final bool refreshAuth;

  const AuthInitScreen({
    super.key,
    required this.refreshAuth,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<AuthInitBloc>();
    return BlocProvider.value(
      value: bloc
        ..add(AuthInitInitialEvent(refreshAuth: refreshAuth))
        ..add(const GetProfileEvent())
        ..add(const CheckSupabaseBiometricsEvent()),
      child: const BlocListener<AuthInitBloc, AuthInitState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  final intl = AppLocalizations.of(context)!;

  if (state is RefreshSuccessState) {
    Modular.to.pop();
  }

  if (state is OpenHomeState) {
    Modular.to.pushNamedAndRemoveUntil(Routes.dashboardRoute, (_) => false);
  }

  if (state is InvalidMasterPasswordState) {
    SnackBarUtils.showErrroSnackBar(context, intl.invalidCredentials);
  }

  if (state is GeneralErrorState) {
    SnackBarUtils.showErrroSnackBar(context, intl.genericError);
  }

  if (state is DeviceAlreadyEnrolledState) {
    Modular.to.pushNamed(Routes.enrollRoute);
  }

  if (state is DeviceNotEnrolledState) {
    Modular.to.pushNamed(Routes.enrollRoute);
  }

  if (state is UserBlockedState) {
    SnackBarUtils.showErrroSnackBar(context, intl.userBlocked);
  }

  if (state is OpenBiometricsEnrollmentState) {
    showEnrollBiometricsDialog(context, intl);
  }

  if (state is BiometricsEnrolledState) {
    SnackBarUtils.showSuccessSnackBar(context, intl.biometricsEnrolled);
    Modular.to.pushNamedAndRemoveUntil(Routes.dashboardRoute, (_) => false);
  }

  if(state is RequestBiometricsState){
    final bloc = Modular.get<AuthInitBloc>();
    bloc.add(const SubmitWithBiometricsEvent());
  }
}

void showEnrollBiometricsDialog(BuildContext context, AppLocalizations intl) {
  final deviceWidth = MediaQuery.of(context).size.width;
  final deviceHeight = MediaQuery.of(context).size.height;
  final bloc = Modular.get<AuthInitBloc>();
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(intl.useBiometrics),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  colorScheme.primary,
                  BlendMode.modulate,
                ),
                child: Lottie.asset(
                  LottiePaths.biometrics,
                  width: deviceWidth * 0.2,
                  height: deviceHeight * 0.2,
                ),
              ),
              SizedBox(height: deviceHeight * 0.015),
              Text(
                intl.enrollBiometrics,
              ),
              SizedBox(height: deviceHeight * 0.015),
            ],
          ),
        ),
        actions: <Widget>[
          AdsFilledButton(
            onPressedCallback: () {
              bloc.add(const EnrollBiometricsEvent(enroll: true));
              Modular.to.pop();
            },
            text: intl.enable,
          ),
          TextButton(
            child: Text(
              intl.skip,
              style: const TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
            onPressed: () {
              bloc.add(const EnrollBiometricsEvent(enroll: false));
              Modular.to.pop();
            },
          ),
        ],
      );
    },
  );
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<AuthInitBloc>();

    return AdsScreenTemplate(
      wrapScroll: false,
      child: PopScope(
        canPop: false,
        child: BlocBuilder<AuthInitBloc, AuthInitState>(
          buildWhen: (previous, current) =>
              previous.model.status != current.model.status,
          builder: (context, state) {
            final status = state.model.status;

            return Skeletonizer(
              enabled: status.isInProgress,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: deviceHeight * (Platform.isAndroid ? 0.05 : 0.02),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AdsHeadline(
                                    text: intl.hello,
                                  ),
                                  BlocBuilder<AuthInitBloc, AuthInitState>(
                                    buildWhen: (previous, current) =>
                                        (previous.model.statusProfile !=
                                            current.model.statusProfile) ||
                                        (previous.model.profile?.displayName !=
                                            current.model.profile?.displayName),
                                    builder: (context, state) {
                                      final displayName =
                                          state.model.profile?.displayName;
                                      final status = state.model.statusProfile;

                                      return Skeletonizer(
                                        enabled: status.isInProgress,
                                        child: Text(
                                          displayName ?? '',
                                          style:
                                              textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              BlocBuilder<AuthInitBloc, AuthInitState>(
                                buildWhen: (previous, current) =>
                                    (previous.model.statusProfile !=
                                        current.model.statusProfile) ||
                                    (previous.model.profile?.avatar !=
                                        current.model.profile?.avatar),
                                builder: (context, state) {
                                  final avatar = state.model.profile?.avatar;
                                  final status = state.model.statusProfile;

                                  return Skeletonizer(
                                    enabled: status.isInProgress,
                                    child: AdsAvatar(
                                      imageUrl: avatar,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: deviceHeight * 0.15),
                          AdsSubtitle(
                            text: intl.authInitText,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: deviceHeight * 0.02),
                          const MasterPasswordWidget(),
                          SizedBox(height: deviceHeight * 0.03),
                          const SubmitButtonWidget(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.01),
                  BlocBuilder<AuthInitBloc, AuthInitState>(
                    buildWhen: (previous, current) =>
                        (previous.model.statusBiometrics !=
                            current.model.statusBiometrics) ||
                        (previous.model.hasBiometricsSaved !=
                            current.model.hasBiometricsSaved),
                    builder: (context, state) {
                      final status = state.model.statusBiometrics;
                      final hasBiometricsSaved = state.model.hasBiometricsSaved;
                      final canAuthenticateWithBiometrics =
                          state.model.canAuthenticateWithBiometrics;

                      if (!status.isInProgress &&
                          (!hasBiometricsSaved ||
                              !canAuthenticateWithBiometrics)) {
                        return AdsTextButton(
                          text: intl.logOut,
                          onPressedCallback: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(intl.attentionTitle),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          intl.logoutText,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    AdsFilledIconButton(
                                      onPressedCallback: () {
                                        supabase.auth.signOut();
                                        Modular.to.pushNamedAndRemoveUntil(
                                          Routes.getStartedRoute,
                                          (_) => false,
                                        );
                                      },
                                      text: intl.acceptButton,
                                      icon: Icons.check,
                                    ),
                                    TextButton(
                                      child: Text(
                                        intl.cancelButton,
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      onPressed: () {
                                        Modular.to.pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.center,
                        );
                      }

                      return Skeletonizer(
                        enabled: status.isInProgress,
                        child: AdsOutlinedIconButton(
                          onPressedCallback: () =>
                              bloc.add(const SubmitWithBiometricsEvent()),
                          text: intl.useBiometrics,
                          icon: Platform.isIOS ? Icons.face : Icons.fingerprint,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
