import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_bloc.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_event.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_state.dart';
import 'package:savepass/core/utils/regex_utils.dart';
import 'package:savepass/l10n/app_localizations.dart';

class RepeatAuthRecoveryPassword extends StatefulWidget {
  const RepeatAuthRecoveryPassword({super.key});

  @override
  State<RepeatAuthRecoveryPassword> createState() =>
      _RepeatAuthRecoveryPasswordState();
}

class _RepeatAuthRecoveryPasswordState
    extends State<RepeatAuthRecoveryPassword> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<AuthBloc>();
    final intl = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
          (previous.model.repeatRecoveryPassword.value !=
              current.model.repeatRecoveryPassword.value) ||
          (previous.model.recoveryPasswordAlreadySubmitted !=
              current.model.recoveryPasswordAlreadySubmitted) ||
          (previous.model.showRepeatRecoveryPassword !=
              current.model.showRepeatRecoveryPassword),
      builder: (context, state) {
        final model = state.model;
        final password = model.repeatRecoveryPassword.value;
        _controller.text = password;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${intl.repeatPassword}:',
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 5,
            ),
            AdsTextField(
              controller: _controller,
              key: const Key('auth_repeatRecoveryPassword_textField'),
              errorText: model.recoveryPasswordAlreadySubmitted
                  ? model.repeatRecoveryPassword
                      .getError(intl, model.repeatRecoveryPassword.error)
                  : null,
              onChanged: (value) {
                bloc.add(ChangeRepeatRecoveryPasswordEvent(password: value));
              },
              obscureText: !model.showRepeatRecoveryPassword,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegexUtils.password,
                ),
              ],
              textInputAction: TextInputAction.done,
              suffixIcon: model.showRepeatRecoveryPassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              onTapSuffixIcon: () =>
                  bloc.add(const ToggleShowRepeatRecoveryPasswordEvent()),
            ),
          ],
        );
      },
    );
  }
}
