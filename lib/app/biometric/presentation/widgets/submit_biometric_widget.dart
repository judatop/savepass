import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/biometric/presentation/blocs/biometric_bloc.dart';
import 'package:savepass/app/biometric/presentation/blocs/biometric_event.dart';

class SubmitBiometricWidget extends StatelessWidget {
  const SubmitBiometricWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<BiometricBloc>();

    return AdsFilledButton(
      onPressedCallback: () {
        bloc.add(const SubmitBiometricEvent());
      },
      text: intl.acceptButton,
    );
  }
}
