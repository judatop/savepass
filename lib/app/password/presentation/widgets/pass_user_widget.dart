import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_state.dart';

class PassUserWidget extends StatelessWidget {
  const PassUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<PasswordBloc>();
    final textTheme = Theme.of(context).textTheme;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          intl.username,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: _User()),
            BlocBuilder<PasswordBloc, PasswordState>(
              buildWhen: (previous, current) =>
                  previous.model.isUpdating != current.model.isUpdating,
              builder: (context, state) {
                if (!state.model.isUpdating) {
                  return Container();
                }

                return Row(
                  children: [
                    SizedBox(
                      width: deviceWidth * 0.03,
                    ),
                    AdsFilledRoundIconButton(
                      icon: const Icon(Icons.copy),
                      onPressedCallback: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        bloc.add(const CopyUserToClipboardEvent());
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _User extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  _User();

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<PasswordBloc>();

    return BlocBuilder<PasswordBloc, PasswordState>(
      buildWhen: (previous, current) =>
          (previous.model.alreadySubmitted != current.model.alreadySubmitted) ||
          (previous.model.email != current.model.email),
      builder: (context, state) {
        final model = state.model;
        final email = model.email.value;
        _controller.text = email;

        return AdsFormField(
          formField: AdsTextField(
            controller: _controller,
            key: const Key('password_user_textField'),
            keyboardType: TextInputType.emailAddress,
            errorText: model.alreadySubmitted
                ? model.email.getError(intl, model.email.error)
                : null,
            enableSuggestions: false,
            onChanged: (value) {
              bloc.add(ChageEmailEvent(email: value));
            },
            textInputAction: TextInputAction.next,
            hintText: intl.usernameHint,
          ),
        );
      },
    );
  }
}
