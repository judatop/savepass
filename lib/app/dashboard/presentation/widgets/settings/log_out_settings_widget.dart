import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:savepass/core/utils/dialog_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LogOutSettingsWidget extends StatelessWidget {
  const LogOutSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<DashboardBloc>();

    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          previous.model.logOutStatus != current.model.logOutStatus,
      builder: (context, state) {
        return Skeletonizer(
          enabled: state.model.logOutStatus.isInProgress,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: AdsTextButton(
                text: intl.logOut,
                onPressedCallback: () => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(intl.logOutTitle),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(intl.logOutWarning),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        AdsFilledIconButton(
                          buttonStyle: DialogUtils.confirmButtonStyle,
                          iconSize: DialogUtils.confirmButtonIconSize,
                          onPressedCallback: () {
                            Modular.to.pop();
                            bloc.add(const LogOutEvent());
                          },
                          text: intl.acceptButton,
                          icon: Icons.check,
                        ),
                        TextButton(
                          child: Text(
                            intl.cancelButton,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onPressed: () => Modular.to.pop(),
                        ),
                      ],
                    );
                  },
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
