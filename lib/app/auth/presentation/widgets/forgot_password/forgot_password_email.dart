import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_bloc.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_event.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_state.dart';

class ForgotPasswordEmail extends StatefulWidget {
  const ForgotPasswordEmail({super.key});

  @override
  State<ForgotPasswordEmail> createState() => _ForgotPasswordEmailState();
}

class _ForgotPasswordEmailState extends State<ForgotPasswordEmail> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<AuthBloc>();

    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
          (previous.model.recoveryEmail != current.model.recoveryEmail) ||
          (previous.model.forgotPasswordAlreadySubmitted !=
              current.model.forgotPasswordAlreadySubmitted),
      builder: (context, state) {
        final model = state.model;
        final email = model.recoveryEmail.value;
        _controller.text = email;

        return AdsFormField(
          label: '${intl.emailSignUpForm}:',
          formField: AdsTextField(
            controller: _controller,
            key: const Key('forgotPassword_email_textField'),
            keyboardType: TextInputType.emailAddress,
            errorText: model.forgotPasswordAlreadySubmitted
                ? model.recoveryEmail.getError(intl, model.recoveryEmail.error)
                : null,
            enableSuggestions: false,
            onChanged: (value) {
              bloc.add(RecoveryEmailChangeEvent(email: value));
            },
            textInputAction: TextInputAction.next,
          ),
        );
      },
    );
  }
}
