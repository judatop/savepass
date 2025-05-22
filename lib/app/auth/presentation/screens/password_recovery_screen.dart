import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_bloc.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_event.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_state.dart';
import 'package:savepass/app/auth/presentation/widgets/recovery_password/auth_recovery_password.dart';
import 'package:savepass/app/auth/presentation/widgets/recovery_password/recovery_password_header.dart';
import 'package:savepass/app/auth/presentation/widgets/recovery_password/recovery_submit.dart';
import 'package:savepass/app/auth/presentation/widgets/recovery_password/repeat_auth_recovery_password.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<AuthBloc>();

    return BlocProvider.value(
      value: bloc..add(const InitRecoveryPasswordEvent()),
      child: const BlocListener<AuthBloc, AuthState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  final intl = AppLocalizations.of(context)!;

  if (state is NewPasswordMustBeDiferentState) {
    SnackBarUtils.showErrroSnackBar(context, intl.newPasswordBeDiferent);
  }

  if (state is NewPasswordSuccessState) {
    final bloc = Modular.get<AuthBloc>();
    bloc.add(const ProcessSignedInEvent());
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
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
              const RecoveryPasswordHeader(),
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (previous, current) =>
                    (previous.model.recoveryStatus !=
                        current.model.recoveryStatus),
                builder: (context, state) {
                  return Skeletonizer(
                    enabled: state.model.recoveryStatus.isInProgress,
                    child: Column(
                      children: [
                        SizedBox(height: deviceHeight * 0.06),
                        Text(intl.newPasswordText),
                        SizedBox(height: deviceHeight * 0.02),
                        const AuthRecoveryPassword(),
                        SizedBox(height: deviceHeight * 0.02),
                        const RepeatAuthRecoveryPassword(),
                        SizedBox(height: deviceHeight * 0.05),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            RecoverySubmit(),
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
