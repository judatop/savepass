import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/master_password/presentation/blocs/master_password_bloc.dart';
import 'package:savepass/app/master_password/presentation/blocs/master_password_event.dart';

class SubmitUpdateMasterPasswordWidget extends StatelessWidget {
  const SubmitUpdateMasterPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<MasterPasswordBloc>();

    return AdsFilledButton(
      onPressedCallback: () {
        bloc.add(const SubmitEvent());
      },
      text: intl.updateText,
    );
  }
}
