import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:savepass/l10n/app_localizations.dart';

class DeleteButtonWidget extends StatelessWidget {
  const DeleteButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<PasswordBloc>();

    return Column(
      children: [
        BlocBuilder<PasswordBloc, PasswordState>(
          buildWhen: (previous, current) =>
              (previous.model.status != current.model.status) ||
              (previous.model.isUpdating != current.model.isUpdating),
          builder: (context, state) {
            final status = state.model.status;

            return Skeletonizer(
              enabled: status.isInProgress,
              child: AdsFilledButton(
                onPressedCallback: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(intl.attentionTitle),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(
                                intl.deletePasswordText,
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          AdsFilledButton(
                            onPressedCallback: () {
                              Modular.to.pop();
                              bloc.add(const DeletePasswordEvent());
                            },
                            text: intl.acceptButton,
                          ),
                          TextButton(
                            child: Text(
                              intl.cancelButton,
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onPressed: () {
                              Modular.to.pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                text: intl.delete,
                buttonStyle: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    ADSFoundationsColors.errorBackground,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
