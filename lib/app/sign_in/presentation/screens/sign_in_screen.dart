import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_bloc.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_event.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_state.dart';
import 'package:savepass/app/sign_in/presentation/widgets/dont_have_account_widget.dart';
import 'package:savepass/app/sign_in/presentation/widgets/sign_in_options_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/core/config/routes.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<SignInBloc>();
    return BlocProvider.value(
      value: bloc..add(const SignInInitialEvent()),
      child: const BlocListener<SignInBloc, SignInState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
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
    final textTheme = Theme.of(context).textTheme;

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
                      Text(
                        appLocalizations.signInTitle,
                        style: textTheme.headlineMedium?.copyWith(
                          fontSize: 26,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: deviceHeight * 0.03),
                      const SignInOptionsWidget(),
                    ],
                  ),
                ),
              ],
            ),
            const DontHaveAccountWidget(),
          ],
        ),
      ),
    );
  }
}
