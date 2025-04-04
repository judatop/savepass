import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/master_password/presentation/blocs/master_password_bloc.dart';
import 'package:savepass/app/master_password/presentation/blocs/master_password_event.dart';
import 'package:savepass/app/master_password/presentation/blocs/master_password_state.dart';
import 'package:savepass/core/utils/regex_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OldPasswordWidget extends StatefulWidget {
  const OldPasswordWidget({super.key});

  @override
  State<OldPasswordWidget> createState() => _OldPasswordWidgettState();
}

class _OldPasswordWidgettState extends State<OldPasswordWidget> {
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
          (previous.model.oldPassword != current.model.oldPassword) ||
          (previous.model.alreadySubmitted != current.model.alreadySubmitted) ||
          (previous.model.showOldPassword != current.model.showOldPassword),
      builder: (context, state) {
        final model = state.model;
        final masterPassword = model.oldPassword.value;
        _controller.text = masterPassword;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdsTextField(
              hintText: intl.enterOldMasterPassword,
              controller: _controller,
              key: const Key('updateMasterPassword_oldPassword_textField'),
              errorText: model.alreadySubmitted
                  ? model.oldPassword.getError(intl, model.oldPassword.error)
                  : null,
              onChanged: (value) {
                bloc.add(OldPasswordChangedEvent(password: value));
              },
              obscureText: !model.showOldPassword,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegexUtils.password,
                ),
              ],
              textInputAction: TextInputAction.next,
              suffixIcon: model.showOldPassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              onTapSuffixIcon: () => bloc.add(const ToggleOldPasswordEvent()),
            ),
          ],
        );
      },
    );
  }
}
