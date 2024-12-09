import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DeleteAccountSettingsWidget extends StatelessWidget {
  const DeleteAccountSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<DashboardBloc>();

    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          previous.model.deleteStatus != current.model.deleteStatus,
      builder: (context, state) {
        return Skeletonizer(
          enabled: state.model.deleteStatus.isInProgress,
          child: AdsCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AdsTitle(
                    text: intl.deleteTitle,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    intl.deleteText,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  AdsFilledButton(
                    onPressedCallback: () =>
                        bloc.add(const DeleteAccountEvent()),
                    text: intl.deleteButton,
                    buttonStyle: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        ADSFoundationsColors.errorBackground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
