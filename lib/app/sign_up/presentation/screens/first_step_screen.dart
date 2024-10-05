import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_bloc.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_event.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_state.dart';
import 'package:savepass/app/sign_up/presentation/widgets/first_step/name_widget.dart';
import 'package:savepass/app/sign_up/presentation/widgets/first_step/terms_widget.dart';
import 'package:savepass/app/sign_up/presentation/widgets/first_step/submit_terms_button_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/core/config/routes.dart';

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

void _listener(context, state) {}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final appLocalizations = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      child: AdsScreenTemplate(
        wrapScroll: false,
        safeAreaBottom: false,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AdsTitle(
                  text: appLocalizations.signUpTitle,
                ),
                SizedBox(height: deviceHeight * 0.04),
                const NameWidget(),
                SizedBox(height: deviceHeight * 0.015),
                const SubmitTermsButtonWidget(),
                SizedBox(height: deviceHeight * 0.04),
                const TermsWidget(),
              ],
            ),
            const _SignUpButton(),
          ],
        ),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appLocalizations = AppLocalizations.of(context)!;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: colorScheme.brightness == Brightness.light
            ? Colors.transparent
            : Colors.black,
        child: Column(
          children: [
            if (colorScheme.brightness == Brightness.light) const Divider(),
            AdsTextButton(
              text: appLocalizations.signUpAlreadyAccount,
              onPressedCallback: () {
                Modular.to.pop();
                Modular.to.pushNamed(Routes.signInRoute);
              },
              textStyle: const TextStyle(
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
