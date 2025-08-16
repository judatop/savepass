import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lottie/lottie.dart';
import 'package:savepass/app/auth/infrastructure/models/auth_type.dart';
import 'package:savepass/app/get_started/presentation/blocs/get_started_bloc.dart';
import 'package:savepass/app/get_started/presentation/blocs/get_started_event.dart';
import 'package:savepass/app/get_started/presentation/blocs/get_started_state.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/lottie/lottie_paths.dart';
import 'package:savepass/l10n/app_localizations.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<GetStartedBloc>();

    return BlocProvider.value(
      value: bloc,
      child: const BlocListener<GetStartedBloc, GetStartedState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  if (state is OpenSignInState) {
    Modular.to.pushNamed(
      Routes.authRoute,
      arguments: AuthType.signIn,
    );
  }

  if (state is OpenSignUpState) {
    Modular.to.pushNamed(
      Routes.authRoute,
      arguments: AuthType.signUp,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<GetStartedBloc>();
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final appLocalizations = AppLocalizations.of(context)!;

    return AdsScreenTemplate(
      safeAreaBottom: false,
      wrapScroll: false,
      child: PopScope(
        canPop: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        colorScheme.primary,
                        BlendMode.modulate,
                      ),
                      child: Lottie.asset(LottiePaths.getStarted),
                    ),
                    AdsHeadline(
                      text: appLocalizations.getStartedTitle,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      appLocalizations.getStartedText,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            AdsFilledButton(
              text: appLocalizations.getStartedSingIn,
              onPressedCallback: () => bloc.add(const OpenSignInEvent()),
            ),
            SizedBox(height: screenHeight * 0.01),
            AdsOutlinedButton(
              onPressedCallback: () => bloc.add(const OpenSignUpEvent()),
              text: appLocalizations.getStartedSingUp,
            ),
          ],
        ),
      ),
    );
  }
}
