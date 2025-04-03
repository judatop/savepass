import 'dart:io';

import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_bloc.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_event.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_state.dart';
import 'package:savepass/app/auth_init/presentation/widgets/master_password_widget.dart';
import 'package:savepass/app/auth_init/presentation/widgets/submit_button_widget.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AuthInitScreen extends StatelessWidget {
  const AuthInitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<AuthInitBloc>();
    return BlocProvider.value(
      value: bloc
        ..add(const AuthInitInitialEvent())
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
                                    style: textTheme.titleMedium?.copyWith(
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

                if (!hasBiometricsSaved || !canAuthenticateWithBiometrics) {
                  return Container();
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
      ),
    );
  }
}
