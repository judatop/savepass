import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/master_password/presentation/blocs/master_password_bloc.dart';
import 'package:savepass/app/master_password/presentation/blocs/master_password_event.dart';
import 'package:savepass/app/master_password/presentation/blocs/master_password_state.dart';
import 'package:savepass/core/utils/regex_utils.dart';
import 'package:savepass/l10n/app_localizations.dart';

class NewPasswordWidget extends StatefulWidget {
  const NewPasswordWidget({super.key});

  @override
  State<NewPasswordWidget> createState() => _NewPasswordWidgetState();
}

class _NewPasswordWidgetState extends State<NewPasswordWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<MasterPasswordBloc>();
    final intl = AppLocalizations.of(context)!;

    return BlocBuilder<MasterPasswordBloc, MasterPasswordState>(
      buildWhen: (previous, current) =>
          (previous.model.newPassword != current.model.newPassword) ||
          (previous.model.alreadySubmitted != current.model.alreadySubmitted) ||
          (previous.model.showNewPassword != current.model.showNewPassword),
      builder: (context, state) {
        final model = state.model;
        final masterPassword = model.newPassword.value;
        _controller.text = masterPassword;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdsTextField(
              hintText: intl.enterNewMasterPassword,
              controller: _controller,
              key: const Key('updateMasterPassword_newPassword_textField'),
              errorText: model.alreadySubmitted
                  ? model.newPassword.getError(intl, model.newPassword.error)
                  : null,
              onChanged: (value) {
                bloc.add(NewPasswordChangedEvent(password: value));
              },
              obscureText: !model.showNewPassword,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegexUtils.password,
                ),
              ],
              textInputAction: TextInputAction.next,
              suffixIcon: model.showNewPassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              onTapSuffixIcon: () => bloc.add(const ToggleNewPasswordEvent()),
            ),
          ],
        );
      },
    );
  }
}
