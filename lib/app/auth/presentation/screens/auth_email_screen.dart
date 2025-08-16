import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/auth/infrastructure/models/auth_type.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_bloc.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_event.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_state.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:savepass/app/auth/presentation/widgets/auth_email/auth_email.dart';
import 'package:savepass/app/auth/presentation/widgets/auth_email/auth_header_widget.dart';
import 'package:savepass/app/auth/presentation/widgets/auth_email/auth_sign_in_password.dart';
import 'package:savepass/app/auth/presentation/widgets/auth_email/auth_sign_up_password.dart';
import 'package:savepass/app/auth/presentation/widgets/auth_email/auth_submit.dart';
import 'package:savepass/app/auth/presentation/widgets/auth_email/forgot_password.dart';
import 'package:savepass/app/auth/presentation/widgets/auth_email/repeat_auth_sign_up_password.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AuthEmailScreen extends StatelessWidget {
  const AuthEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<AuthBloc>();

    return BlocProvider.value(
      value: bloc..add(const AuthEmailInitialEvent()),
      child: const BlocListener<AuthBloc, AuthState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  final intl = AppLocalizations.of(context)!;

  if (state is EmailAlreadyUsedState) {
    SnackBarUtils.showErrroSnackBar(
      context,
      intl.emailAlreadyInUse,
    );
  }

  if (state is GeneralErrorState) {
    SnackBarUtils.showErrroSnackBar(
      context,
      intl.genericError,
    );
  }

  if (state is OpenSyncPassState) {
    Modular.to
        .pushNamedAndRemoveUntil(Routes.syncMasterPasswordRoute, (_) => false);
  }

  if (state is PasswordsMismatch) {
    SnackBarUtils.showErrroSnackBar(
      context,
      intl.passwordMissmatch,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return AdsScreenTemplate(
      safeAreaBottom: false,
      safeAreaTop: true,
      wrapScroll: false,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.only(
          left: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
          right: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
          bottom: deviceHeight * ADSFoundationSizes.defaultVerticalPadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AuthHeaderWidget(),
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (previous, current) =>
                    (previous.model.status != current.model.status),
                builder: (context, state) {
                  final authType = state.model.authType;

                  return Skeletonizer(
                    enabled: state.model.status.isInProgress,
                    child: Column(
                      children: [
                        SizedBox(height: deviceHeight * 0.06),
                        const AuthEmail(),
                        SizedBox(height: deviceHeight * 0.02),
                        if (authType == AuthType.signUp)
                          Column(
                            children: [
                              const AuthSignUpPassword(),
                              SizedBox(height: deviceHeight * 0.02),
                              const RepeatAuthSignUpPassword(),
                            ],
                          ),
                        if (authType == AuthType.signIn)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AuthSignInPassword(),
                              SizedBox(height: deviceHeight * 0.01),
                              const ForgotPassword(),
                            ],
                          ),
                        SizedBox(height: deviceHeight * 0.05),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AuthSubmit(),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
