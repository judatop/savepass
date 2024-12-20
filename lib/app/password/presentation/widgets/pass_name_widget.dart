import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/password/presentation/blocs/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password_state.dart';
import 'package:savepass/core/utils/regex_utils.dart';

class PassNameWidget extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  PassNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<PasswordBloc>();

    return BlocBuilder<PasswordBloc, PasswordState>(
      buildWhen: (previous, current) =>
          (previous.model.name != current.model.name),
      builder: (context, state) {
        final model = state.model;
        final name = model.name.value;
        _controller.text = name;

        return AdsFormField(
          label: 'Name',
          formField: AdsTextField(
            controller: _controller,
            key: const Key('password_name_textField'),
            keyboardType: TextInputType.text,
            errorText: model.alreadySubmitted
                ? model.name.getError(intl, model.name.error)
                : null,
            enableSuggestions: false,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegexUtils.numbersAndLettersWithSpace,
              ),
            ],
            onChanged: (value) {
              bloc.add(ChangeNameEvent(name: value));
            },
            textInputAction: TextInputAction.next,
            hintText: 'Instagram',
          ),
        );
      },
    );
  }
}
