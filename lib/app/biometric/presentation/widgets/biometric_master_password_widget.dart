import 'package:atomic_design_system/molecules/text/ads_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/biometric/presentation/blocs/biometric_bloc.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:savepass/app/biometric/presentation/blocs/biometric_event.dart';
import 'package:savepass/app/biometric/presentation/blocs/biometric_state.dart';
import 'package:savepass/core/utils/regex_utils.dart';

class BiometricMasterPasswordWidget extends StatefulWidget {
  const BiometricMasterPasswordWidget({super.key});

  @override
  State<BiometricMasterPasswordWidget> createState() =>
      _BiometricMasterPasswordWidgetState();
}

class _BiometricMasterPasswordWidgetState
    extends State<BiometricMasterPasswordWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<BiometricBloc>();
    final intl = AppLocalizations.of(context)!;

    return BlocBuilder<BiometricBloc, BiometricState>(
      buildWhen: (previous, current) =>
          (previous.model.masterPassword != current.model.masterPassword) ||
          (previous.model.alreadySubmitted != current.model.alreadySubmitted) ||
          (previous.model.showPassword != current.model.showPassword),
      builder: (context, state) {
        final model = state.model;
        final masterPassword = model.masterPassword.value;
        _controller.text = masterPassword;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdsTextField(
              hintText: intl.enterMasterPassword,
              controller: _controller,
              key: const Key('biometric_masterPassword_textField'),
              errorText: model.alreadySubmitted
                  ? model.masterPassword
                      .getError(intl, model.masterPassword.error)
                  : null,
              onChanged: (value) {
                final bloc = Modular.get<BiometricBloc>();
                bloc.add(BiometricPasswordChangedEvent(password: value));
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
