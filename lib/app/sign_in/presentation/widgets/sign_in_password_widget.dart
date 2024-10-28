import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_bloc.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_event.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_state.dart';
import 'package:savepass/core/utils/regex_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInPasswordWidget extends StatefulWidget {
  const SignInPasswordWidget({super.key});

  @override
  State<SignInPasswordWidget> createState() => _SignInPasswordWidgetState();
}

class _SignInPasswordWidgetState extends State<SignInPasswordWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<SignInBloc>();
    final intl = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) =>
          (previous.model.password != current.model.password) ||
          (previous.model.alreadySubmitted != current.model.alreadySubmitted) ||
          (previous.model.showMasterPassword !=
              current.model.showMasterPassword),
      builder: (context, state) {
        final model = state.model;
        final masterPassword = model.password.value;
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
            AdsTextField(
              controller: _controller,
              key: const Key('signIn_masterPassword_textField'),
              errorText: model.alreadySubmitted
                  ? model.password.getError(intl, model.password.error)
                  : null,
              onChanged: (value) {
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
