import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_bloc.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_event.dart';

class SignInSubmitButtonWidget extends StatelessWidget {
  const SignInSubmitButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return AdsFilledIconButton(
      onPressedCallback: () {
        final bloc = Modular.get<SignInBloc>();
        bloc.add(const SubmitSignInFormEvent());
      },
      text: appLocalizations.signUpButtonText,
      icon: Icons.check,
    );
  }
}
