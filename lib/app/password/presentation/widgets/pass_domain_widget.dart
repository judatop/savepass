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

class PassDomainWidget extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  PassDomainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<PasswordBloc>();

    return BlocBuilder<PasswordBloc, PasswordState>(
      buildWhen: (previous, current) =>
          (previous.model.singleTag != current.model.singleTag),
      builder: (context, state) {
        final model = state.model;
        final singleTag = model.singleTag.value;
        _controller.text = singleTag;

        return AdsFormField(
          label: intl.domain,
          formField: AdsTextField(
            controller: _controller,
            key: const Key('password_domain_textField'),
            keyboardType: TextInputType.text,
            errorText: model.alreadySubmitted
                ? model.singleTag.getError(intl, model.singleTag.error)
                : null,
            enableSuggestions: false,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegexUtils.regexDomain,
              ),
            ],
            onChanged: (value) {
              bloc.add(ChangeTagEvent(tag: value));
            },
            textInputAction: TextInputAction.done,
            hintText: intl.domainHint,
          ),
        );
      },
    );
  }
}
