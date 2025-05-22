import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_bloc.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_event.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_state.dart';
import 'package:savepass/core/utils/regex_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthSignUpPassword extends StatefulWidget {
  const AuthSignUpPassword({super.key});

  @override
  State<AuthSignUpPassword> createState() => _AuthSignUpPasswordState();
}

class _AuthSignUpPasswordState extends State<AuthSignUpPassword> {
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
          (previous.model.signUpPassword != current.model.signUpPassword) ||
          (previous.model.alreadySubmitted != current.model.alreadySubmitted) ||
          (previous.model.showPassword != current.model.showPassword),
      builder: (context, state) {
        final model = state.model;
        final masterPassword = model.signUpPassword.value;
        _controller.text = masterPassword;

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
              key: const Key('signUp_masterPassword_textField'),
              errorText: model.alreadySubmitted
                  ? model.signUpPassword
                      .getError(intl, model.signUpPassword.error)
                  : null,
              onChanged: (value) {
                final bloc = Modular.get<AuthBloc>();
                bloc.add(PasswordChangedEvent(password: value));
              },
              obscureText: !model.showPassword,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegexUtils.password,
                ),
              ],
              textInputAction: TextInputAction.done,
              suffixIcon:
                  model.showPassword ? Icons.visibility_off : Icons.visibility,
              onTapSuffixIcon: () =>
                  bloc.add(const ToggleMasterPasswordEvent()),
            ),
          ],
        );
      },
    );
  }
}
