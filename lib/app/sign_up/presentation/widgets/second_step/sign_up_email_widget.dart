import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_bloc.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_event.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpEmailWidget extends StatelessWidget {
  const SignUpEmailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          (previous.model.email != current.model.email) ||
          (previous.model.alreadySubmitted != current.model.alreadySubmitted),
      builder: (context, state) {
        final model = state.model;

        return AdsFormField(
          label: '${intl.emailSignUpForm}:',
          formField: AdsTextField(
            key: const Key('signUp_email_textField'),
            keyboardType: TextInputType.emailAddress,
            errorText: model.alreadySubmitted
                ? model.email.getError(intl, model.email.error)
                : null,
            enableSuggestions: false,
            onChanged: (value) {
              final bloc = Modular.get<SignUpBloc>();
              bloc.add(EmailChangedEvent(email: value));
            },
            textInputAction: TextInputAction.next,
          ),
        );
      },
    );
  }
}
