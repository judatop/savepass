import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_bloc.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_event.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthEmail extends StatefulWidget {
  const AuthEmail({super.key});

  @override
  State<AuthEmail> createState() => _AuthEmailState();
}

class _AuthEmailState extends State<AuthEmail> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
          (previous.model.email != current.model.email) ||
          (previous.model.alreadySubmitted != current.model.alreadySubmitted),
      builder: (context, state) {
        final model = state.model;
        final email = model.email.value;
        _controller.text = email;

        return AdsFormField(
          label: '${intl.emailSignUpForm}:',
          formField: AdsTextField(
            controller: _controller,
            key: const Key('signUp_email_textField'),
            keyboardType: TextInputType.emailAddress,
            errorText: model.alreadySubmitted
                ? model.email.getError(intl, model.email.error)
                : null,
            enableSuggestions: false,
            onChanged: (value) {
              final bloc = Modular.get<AuthBloc>();
              bloc.add(EmailChangedEvent(email: value));
            },
            textInputAction: TextInputAction.next,
          ),
        );
      },
    );
  }
}
