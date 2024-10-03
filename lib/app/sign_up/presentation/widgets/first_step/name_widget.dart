import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_bloc.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_event.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_state.dart';

class NameWidget extends StatelessWidget {
  const NameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<SignUpBloc>();
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          (previous.model.name != current.model.name) ||
          (previous.model.submitAlredyClicked !=
              current.model.submitAlredyClicked),
      builder: (context, state) {
        final model = state.model;

        return AdsFormField(
          formField: AdsTextField(
            key: const Key('formSignUp_nameTermsInput_textField'),
            onChanged: (value) => bloc.add(NameSignUpChangedEvent(name: value)),
            keyboardType: TextInputType.emailAddress,
            errorText: model.submitAlredyClicked
                ? model.name.getError(context, model.name.error)
                : null,
            enableSuggestions: false,
          ),
        );
      },
    );
  }
}
