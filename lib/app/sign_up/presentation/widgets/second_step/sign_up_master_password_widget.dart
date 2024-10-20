import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_bloc.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_event.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_state.dart';
import 'package:savepass/core/utils/regex_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpMasterPasswordWidget extends StatefulWidget {
  const SignUpMasterPasswordWidget({super.key});

  @override
  State<SignUpMasterPasswordWidget> createState() =>
      _SignUpMasterPasswordWidgetState();
}

class _SignUpMasterPasswordWidgetState
    extends State<SignUpMasterPasswordWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<SignUpBloc>();
    final intl = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          (previous.model.masterPassword != current.model.masterPassword) ||
          (previous.model.alreadySubmitted != current.model.alreadySubmitted) ||
          (previous.model.showMasterPassword !=
              current.model.showMasterPassword),
      builder: (context, state) {
        final model = state.model;
        final masterPassword = model.masterPassword.value;
        _controller.text = masterPassword;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${intl.masterPasswordSignUpForm}:',
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              intl.masterPasswordText,
            ),
            const SizedBox(
              height: 5,
            ),
            AdsTextField(
              controller: _controller,
              key: const Key('signUp_masterPassword_textField'),
              errorText: model.alreadySubmitted
                  ? model.masterPassword
                      .getError(intl, model.masterPassword.error)
                  : null,
              onChanged: (value) {
                final bloc = Modular.get<SignUpBloc>();
                bloc.add(PasswordChangedEvent(password: value));
              },
              obscureText: !model.showMasterPassword,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegexUtils.password,
                ),
              ],
              textInputAction: TextInputAction.done,
              suffixIcon: model.showMasterPassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              onTapSuffixIcon: () =>
                  bloc.add(const ToggleMasterPasswordEvent()),
            ),
          ],
        );
      },
    );
  }
}
