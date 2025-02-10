import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_state.dart';

class PassDescWidget extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  PassDescWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<PasswordBloc>();

    return BlocBuilder<PasswordBloc, PasswordState>(
      buildWhen: (previous, current) =>
          (previous.model.desc != current.model.desc),
      builder: (context, state) {
        final model = state.model;
        final desc = model.desc.value;
        _controller.text = desc;

        return AdsFormField(
          label: intl.passDesc,
          formField: AdsTextField(
            controller: _controller,
            key: const Key('password_desc_textField'),
            keyboardType: TextInputType.text,
            enableSuggestions: false,
            onChanged: (value) {
              bloc.add(ChangeDescEvent(desc: value));
            },
            textInputAction: TextInputAction.done,
            maxLines: 3,
            hintText: intl.optionalForm,
          ),
        );
      },
    );
  }
}
