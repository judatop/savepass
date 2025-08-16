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

class AuthRecoveryPassword extends StatefulWidget {
  const AuthRecoveryPassword({super.key});

  @override
  State<AuthRecoveryPassword> createState() => _AuthRecoveryPasswordState();
}

class _AuthRecoveryPasswordState extends State<AuthRecoveryPassword> {
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
          (previous.model.recoveryPassword != current.model.recoveryPassword) ||
          (previous.model.recoveryPasswordAlreadySubmitted !=
              current.model.recoveryPasswordAlreadySubmitted) ||
          (previous.model.showRecoveryPassword !=
              current.model.showRecoveryPassword),
      builder: (context, state) {
        final model = state.model;
        final recoveryPassword = model.recoveryPassword.value;
        _controller.text = recoveryPassword;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${intl.password}:',
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 5,
            ),
            AdsTextField(
              controller: _controller,
              key: const Key('auth_recoveryPassword_textField'),
              errorText: model.recoveryPasswordAlreadySubmitted
                  ? model.recoveryPassword
                      .getError(intl, model.recoveryPassword.error)
                  : null,
              onChanged: (value) {
                bloc.add(ChangeRecoveryPasswordEvent(password: value));
              },
              obscureText: !model.showRecoveryPassword,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegexUtils.password,
                ),
              ],
              textInputAction: TextInputAction.done,
              suffixIcon: model.showRecoveryPassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              onTapSuffixIcon: () =>
                  bloc.add(const ToggleShowRecoveryPasswordEvent()),
            ),
          ],
        );
      },
    );
  }
}
