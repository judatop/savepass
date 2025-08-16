import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_bloc.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_event.dart';

class AuthSubmit extends StatelessWidget {
  const AuthSubmit({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return AdsFilledIconButton(
      onPressedCallback: () {
        final bloc = Modular.get<AuthBloc>();
        bloc.add(const AuthWithEmailEvent());
      },
      text: appLocalizations.signUpButtonText,
      icon: Icons.check,
    );
  }
}
