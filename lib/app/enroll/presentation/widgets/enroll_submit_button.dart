import 'package:atomic_design_system/molecules/button/ads_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/enroll/presentation/blocs/enroll_bloc.dart';
import 'package:savepass/app/enroll/presentation/blocs/enroll_event.dart';

class EnrollSubmitButton extends StatelessWidget {
  const EnrollSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AdsFilledButton(
      onPressedCallback: () {
        final bloc = Modular.get<EnrollBloc>();
        bloc.add(const SubmitEnrollEvent());
      },
      text: intl.linkDevice,
    );
  }
}
