import 'dart:io';

import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:local_auth/local_auth.dart';
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
      value: bloc..add(const AuthInitInitialEvent()),
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
    Modular.to.pushNamedAndRemoveUntil(Routes.homeRoute, (_) => false);
  }

  if (state is InvalidMasterPasswordState) {
    SnackBarUtils.showErrroSnackBar(context, intl.invalidCredentials);
  }
}

class _Body extends StatelessWidget {
  const _Body();

  void _openBiometrics(BuildContext context) async {
    try {
      final intl = AppLocalizations.of(context)!;

      final LocalAuthentication auth = LocalAuthentication();

      final bool isDeviceSupported = await auth.isDeviceSupported();

      bool isAuthenticated = false;

      if (isDeviceSupported) {
        final bool canAuthenticateWithBiometrics =
            await auth.canCheckBiometrics;
        final bool canAuthenticate =
            canAuthenticateWithBiometrics || await auth.isDeviceSupported();
        if (canAuthenticate) {
          isAuthenticated = await auth.authenticate(
            localizedReason: intl.authBiometricMsg,
            options: const AuthenticationOptions(
              biometricOnly: true,
              useErrorDialogs: false,
            ),
          );
        } else {
          isAuthenticated = await auth.authenticate(
            localizedReason: intl.authBiometricMsg,
          );
        }
      } else {
        if (context.mounted) {
          _showNoBiometricDialog(context);
        }
      }

      if (isAuthenticated) {
        Modular.to.navigate(Routes.homeRoute);
      }
    } catch (error) {
      if (error is PlatformException) {
        if (error.code == 'NotEnrolled') {
          if (context.mounted) {
            _showNoBiometricDialog(context);
          }
        }
      }
    }
  }

  void _showNoBiometricDialog(BuildContext context) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const _BiometricNotEnrolled();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    // final user = FirebaseAuth.instance.currentUser;
    final textTheme = Theme.of(context).textTheme;
    final intl = AppLocalizations.of(context)!;

    return AdsScreenTemplate(
      wrapScroll: false,
      child: BlocBuilder<AuthInitBloc, AuthInitState>(
        buildWhen: (previous, current) =>
            (previous.model.status != current.model.status),
        builder: (context, state) {
          return Skeletonizer(
            enabled: state.model.status.isInProgress,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: deviceHeight * 0.02),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         AdsHeadline(
                        //           text: intl.hello,
                        //         ),
                        //         if (user?.displayName != null)
                        //           Text(
                        //             user!.displayName!,
                        //             style: textTheme.titleMedium?.copyWith(
                        //               fontWeight: FontWeight.w400,
                        //             ),
                        //           ),
                        //       ],
                        //     ),
                        //     AdsAvatar(
                        //       imageUrl: user?.photoURL,
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: deviceHeight * 0.15),
                        Text(
                          intl.authInitText,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: deviceHeight * 0.02),
                        const MasterPasswordWidget(),
                        SizedBox(height: deviceHeight * 0.02),
                        const SubmitButtonWidget(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: deviceHeight * 0.01),
                AdsOutlinedIconButton(
                  onPressedCallback: () => _openBiometrics(context),
                  text: intl.useBiometrics,
                  icon: Platform.isIOS ? Icons.face : Icons.fingerprint,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BiometricNotEnrolled extends StatelessWidget {
  const _BiometricNotEnrolled();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: const Text('Atenttion'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Your Biometrics are not enrolled, in order to proceed you need to configure your biometrics in your settings',
              ),
            ],
          ),
        ),
        actions: <Widget>[
          AdsFilledButton(
            onPressedCallback: () {
              Modular.to.pop();
            },
            text: 'Entendido',
          ),
        ],
      ),
    );
  }
}
