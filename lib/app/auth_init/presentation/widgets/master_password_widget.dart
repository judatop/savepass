import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_bloc.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_event.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_state.dart';
import 'package:savepass/core/utils/regex_utils.dart';
import 'package:savepass/l10n/app_localizations.dart';

class MasterPasswordWidget extends StatefulWidget {
  const MasterPasswordWidget({super.key});

  @override
  State<MasterPasswordWidget> createState() => _MasterPasswordWidgetState();
}

class _MasterPasswordWidgetState extends State<MasterPasswordWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<AuthInitBloc>();
    final intl = AppLocalizations.of(context)!;

    return BlocBuilder<AuthInitBloc, AuthInitState>(
      buildWhen: (previous, current) =>
          (previous.model.password != current.model.password) ||
          (previous.model.alreadySubmitted != current.model.alreadySubmitted) ||
          (previous.model.showPassword != current.model.showPassword),
      builder: (context, state) {
        final model = state.model;
        final masterPassword = model.password.value;

        if (_controller.text != masterPassword) {
          final previousSelection = _controller.selection;
          _controller.value = TextEditingValue(
            text: masterPassword,
            selection: previousSelection,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdsTextField(
              hintText: intl.masterPasswordSignUpForm,
              controller: _controller,
              key: const Key('signUp_masterPassword_textField'),
              errorText: model.alreadySubmitted
                  ? model.password.getError(intl, model.password.error)
                  : null,
              onChanged: (value) {
                final bloc = Modular.get<AuthInitBloc>();
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
              enableSuggestions: false,
            ),
          ],
        );
      },
    );
  }
}
