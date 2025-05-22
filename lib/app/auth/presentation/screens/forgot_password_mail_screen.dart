import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_bloc.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_event.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_state.dart';
import 'package:savepass/app/auth/presentation/widgets/forgot_password/forgot_password_email.dart';
import 'package:savepass/app/auth/presentation/widgets/forgot_password/forgot_password_header.dart';
import 'package:savepass/app/auth/presentation/widgets/forgot_password/forgot_password_submit.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordMailScreen extends StatelessWidget {
  const ForgotPasswordMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<AuthBloc>();

    return BlocProvider.value(
      value: bloc..add(const InitForgotPasswordEvent()),
      child: const BlocListener<AuthBloc, AuthState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  if (state is RecoveryEmailSent) {
    Modular.to.pushNamed(Routes.emailSentRoute);
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
              const ForgotPasswordHeader(),
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (previous, current) =>
                    (previous.model.forgotPasswordStatus !=
                        current.model.forgotPasswordStatus),
                builder: (context, state) {
                  return Skeletonizer(
                    enabled: state.model.forgotPasswordStatus.isInProgress,
                    child: Column(
                      children: [
                        SizedBox(height: deviceHeight * 0.06),
                        Text(intl.forgotPasswordText),
                        SizedBox(height: deviceHeight * 0.02),
                        const ForgotPasswordEmail(),
                        SizedBox(height: deviceHeight * 0.02),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ForgotPasswordSubmit(),
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
