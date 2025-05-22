import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_bloc.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_event.dart';

class RecoverySubmit extends StatelessWidget {
  const RecoverySubmit({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final bloc = Modular.get<AuthBloc>();

    return AdsFilledIconButton(
      onPressedCallback: () => bloc.add(const RecoveryPasswordSubmitEvent()),
      text: appLocalizations.signUpButtonText,
      icon: Icons.check,
    );
  }
}
