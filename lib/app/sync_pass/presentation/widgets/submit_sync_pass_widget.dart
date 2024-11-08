import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/sync_pass/presentation/blocs/sync_bloc.dart';
import 'package:savepass/app/sync_pass/presentation/blocs/sync_event.dart';

class SubmitSyncPassWidget extends StatelessWidget {
  const SubmitSyncPassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return AdsFilledIconButton(
      onPressedCallback: () {
        final bloc = Modular.get<SyncBloc>();
        bloc.add(const SubmitSyncPasswordEvent());
      },
      text: appLocalizations.signUpButtonText,
      icon: Icons.check,
    );
  }
}
