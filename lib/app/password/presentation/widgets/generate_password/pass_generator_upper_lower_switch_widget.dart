import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PassGeneratorUpperLowerSwitchWidget extends StatelessWidget {
  const PassGeneratorUpperLowerSwitchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<PasswordBloc>();
    final deviceWidth = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;
    final intl = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          intl.uppwerLowerCaseText,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        SizedBox(
          width: deviceWidth * 0.03,
        ),
        BlocBuilder<PasswordBloc, PasswordState>(
          buildWhen: (previous, current) =>
              (previous.model.upperLowerCase != current.model.upperLowerCase) ||
              (previous.model.easyToRead != current.model.easyToRead),
          builder: (context, state) {
            final easyToRead = state.model.easyToRead;
            final value = state.model.upperLowerCase;

            return Switch(
              value: value,
              activeColor: colorScheme.primary,
              onChanged: easyToRead
                  ? null
                  : (bool value) {
                      bloc.add(const ChangeUpperLowerCaseEvent());
                      bloc.add(const GenerateRandomPasswordEvent());
                    },
            );
          },
        ),
      ],
    );
  }
}
