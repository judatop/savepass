import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_bloc.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_event.dart';

class SignUpSubmitButtonWidget extends StatelessWidget {
  const SignUpSubmitButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return AdsFilledIconButton(
      onPressedCallback: () {
        final bloc = Modular.get<SignUpBloc>();
        bloc.add(const SubmitSignUpFormEvent());
      },
      text: appLocalizations.signUpButtonText,
      icon: Icons.check,
    );
  }
}
