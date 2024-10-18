import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_bloc.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_event.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NameWidget extends StatelessWidget {
  const NameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<SignUpBloc>();
    final intl = AppLocalizations.of(context)!;

    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          (previous.model.name != current.model.name) ||
          (previous.model.alreadySubmitted != current.model.alreadySubmitted),
      builder: (context, state) {
        final model = state.model;
        debugPrint('NameWidget: ${model.name.value}');
        return AdsFormField(
          formField: AdsTextField(
            key: const Key('formSignUp_nameInput_textField'),
            onChanged: (value) => bloc.add(NameSignUpChangedEvent(name: value)),
            keyboardType: TextInputType.text,
            errorText: model.alreadySubmitted
                ? model.name.getError(intl, model.name.error)
                : null,
            prefixIcon: Icons.person,
            enableSuggestions: false,
          ),
        );
      },
    );
  }
}
