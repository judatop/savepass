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

class RepeatPasswordWidget extends StatefulWidget {
  const RepeatPasswordWidget({super.key});

  @override
  State<RepeatPasswordWidget> createState() => _RepeatPasswordWidgetState();
}

class _RepeatPasswordWidgetState extends State<RepeatPasswordWidget> {
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
          (previous.model.repeatNewPassword != current.model.repeatNewPassword) ||
          (previous.model.alreadySubmitted != current.model.alreadySubmitted) ||
          (previous.model.showRepeatNewPassword != current.model.showRepeatNewPassword),
      builder: (context, state) {
        final model = state.model;
        final masterPassword = model.repeatNewPassword.value;
        _controller.text = masterPassword;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdsTextField(
              hintText: intl.repeatMasterPassword,
              controller: _controller,
              key: const Key('updateMasterPassword_repeatNewPassword_textField'),
              errorText: model.alreadySubmitted
                  ? model.repeatNewPassword.getError(intl, model.repeatNewPassword.error)
                  : null,
              onChanged: (value) {
                bloc.add(RepeatPasswordChangedEvent(password: value));
              },
              obscureText: !model.showRepeatNewPassword,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegexUtils.password,
                ),
              ],
              textInputAction: TextInputAction.done,
              suffixIcon: model.showRepeatNewPassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              onTapSuffixIcon: () => bloc.add(const ToggleRepeatPasswordEvent()),
            ),
          ],
        );
      },
    );
  }
}
