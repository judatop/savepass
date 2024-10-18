import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_bloc.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_event.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_state.dart';
import 'package:savepass/app/sign_up/presentation/widgets/first_step/already_have_account_widget.dart';
import 'package:savepass/app/sign_up/presentation/widgets/first_step/sign_up_options_widget.dart';
import 'package:savepass/app/sign_up/presentation/widgets/first_step/terms_widget.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FirstStepScreen extends StatelessWidget {
  const FirstStepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<SignUpBloc>();
    return BlocProvider.value(
      value: bloc..add(const SignUpInitialEvent()),
      child: const BlocListener<SignUpBloc, SignUpState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  if (state is OpenSignInState) {
    Modular.to.popAndPushNamed(Routes.signInRoute);
  }

  if (state is OpenPrivacyPolicyState) {
    Modular.to.pushNamed(Routes.privacyPolicyRoute);
  }

  if (state is OpenSecondStepState) {
    Modular.to.pushNamed(Routes.singUpSecondStepRoute);
  }

  if (state is OpenHomeState) {
    Modular.to.popAndPushNamed(Routes.homeRoute);
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final appLocalizations = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      child: AdsScreenTemplate(
        wrapScroll: false,
        safeAreaBottom: false,
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: deviceWidth *
                        ADSFoundationSizes.defaultHorizontalPadding,
                    right: deviceWidth *
                        ADSFoundationSizes.defaultHorizontalPadding,
                  ),
                  child: Column(
                    children: [
                      AdsHeadline(text: appLocalizations.authTitle),
                      SizedBox(height: deviceHeight * 0.05),
                      const SignUpOptionsWidget(),
                      SizedBox(height: deviceHeight * 0.04),
                      const TermsWidget(),
                    ],
                  ),
                ),
              ],
            ),
            const AlreadyHaveAccountWidget(),
          ],
        ),
      ),
    );
  }
}
