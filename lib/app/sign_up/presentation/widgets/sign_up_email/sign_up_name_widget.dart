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

class SignUpNameWidget extends StatefulWidget {
  const SignUpNameWidget({super.key});

  @override
  State<SignUpNameWidget> createState() => _SignUpNameWidgetState();
}

class _SignUpNameWidgetState extends State<SignUpNameWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          (previous.model.name != current.model.name) ||
          (previous.model.alreadySubmitted != current.model.alreadySubmitted),
      builder: (context, state) {
        final name = state.model.name.value;
        _controller.text = name;

        return AdsFormField(
          label: '${appLocalizations.nameSignUpForm}:',
          formField: AdsTextField(
            controller: _controller,
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