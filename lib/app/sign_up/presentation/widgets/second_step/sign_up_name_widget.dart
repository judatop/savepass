import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_bloc.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_event.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_state.dart';
import 'package:savepass/core/utils/regex_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpNameWidget extends StatelessWidget {
  const SignUpNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          (previous.model.name != current.model.name) ||
          (previous.model.alreadySubmitted != current.model.alreadySubmitted),
      builder: (context, state) {
        return AdsFormField(
          label: '${appLocalizations.nameSignUpForm}:',
          formField: AdsTextField(
            hintText: appLocalizations.optionalForm,
            key: const Key('signUp_name_textField'),
            keyboardType: TextInputType.text,
            enableSuggestions: false,
            onChanged: (value) {
              final bloc = Modular.get<SignUpBloc>();
              bloc.add(NameChangedEvent(name: value));
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegexUtils.numbersAndLettersWithSpace,
              ),
            ],
            textInputAction: TextInputAction.next,
          ),
        );
      },
    );
  }
}
