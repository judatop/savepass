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

class RepeatAuthSignUpPassword extends StatefulWidget {
  const RepeatAuthSignUpPassword({super.key});

  @override
  State<RepeatAuthSignUpPassword> createState() =>
      _RepeatAuthSignUpPasswordState();
}

class _RepeatAuthSignUpPasswordState extends State<RepeatAuthSignUpPassword> {
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
          (previous.model.repeatSignUpPassword.value !=
              current.model.repeatSignUpPassword.value) ||
          (previous.model.alreadySubmitted != current.model.alreadySubmitted) ||
          (previous.model.repeatShowPassword !=
              current.model.repeatShowPassword),
      builder: (context, state) {
        final model = state.model;
        final masterPassword = model.repeatSignUpPassword.value;
        _controller.text = masterPassword;

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
              key: const Key('signUp_repeatPassword_textField'),
              errorText: model.alreadySubmitted
                  ? model.repeatSignUpPassword
                      .getError(intl, model.repeatSignUpPassword.error)
                  : null,
              onChanged: (value) {
                final bloc = Modular.get<AuthBloc>();
                bloc.add(RepeatPasswordChangedEvent(password: value));
              },
              obscureText: !model.repeatShowPassword,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegexUtils.password,
                ),
              ],
              textInputAction: TextInputAction.done,
              suffixIcon: model.repeatShowPassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              onTapSuffixIcon: () =>
                  bloc.add(const ToggleRepeatPasswordEvent()),
            ),
          ],
        );
      },
    );
  }
}
