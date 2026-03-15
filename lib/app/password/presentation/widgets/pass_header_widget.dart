import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PassHeaderWidget extends StatelessWidget {
  const PassHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<PasswordBloc>();
    final intl = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<PasswordBloc, PasswordState>(
      buildWhen: (previous, current) =>
          previous.model.isUpdating != current.model.isUpdating,
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              height: (ADSFoundationSizes.defaultVerticalPadding / 2) *
                  screenHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<PasswordBloc, PasswordState>(
                  buildWhen: (previous, current) =>
                      (previous.model.name.value != current.model.name.value) ||
                      (previous.model.email.value !=
                          current.model.email.value) ||
                      (previous.model.password.value !=
                          current.model.password.value) ||
                      (previous.model.singleTag.value !=
                          current.model.singleTag.value) ||
                      (previous.model.desc.value != current.model.desc.value),
                  builder: (context, state) {
                    final name = state.model.name.value;
                    final email = state.model.email.value;
                    final password = state.model.password.value;
                    final singleTag = state.model.singleTag.value;
                    final desc = state.model.desc.value;

                    return AdsFilledRoundIconButton(
                      icon: const Icon(
                        Icons.keyboard_arrow_left,
                      ),
                      onPressedCallback: () {
                        if (name.isEmpty &&
                            email.isEmpty &&
                            password.isEmpty &&
                            singleTag.isEmpty &&
                            desc.isEmpty) {
                          Modular.to.pop();
                          return;
                        }

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
                                      intl.goBackText,
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                AdsFilledIconButton(
                                  onPressedCallback: () {
                                    Modular.to.pop();
                                    Modular.to.pop();
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
                                  onPressed: () {
                                    Modular.to.pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                BlocBuilder<PasswordBloc, PasswordState>(
                  buildWhen: (previous, current) =>
                      (previous.model.status != current.model.status) ||
                      (previous.model.isUpdating != current.model.isUpdating),
                  builder: (context, state) {
                    final status = state.model.status;
                    final isUpdating = state.model.isUpdating;

                    return Skeletonizer(
                      enabled: status.isInProgress,
                      child: AdsFilledButton(
                        onPressedCallback: () =>
                            bloc.add(const SubmitPasswordEvent()),
                        text: isUpdating ? intl.editText : intl.saveText,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
