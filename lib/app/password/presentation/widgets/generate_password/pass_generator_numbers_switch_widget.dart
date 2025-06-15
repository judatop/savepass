import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_state.dart';

class PassGeneratorNumbersSwitchWidget extends StatelessWidget {
  const PassGeneratorNumbersSwitchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<PasswordBloc>();
    final deviceWidth = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Numbers',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        SizedBox(
          width: deviceWidth * 0.03,
        ),
        BlocBuilder<PasswordBloc, PasswordState>(
          buildWhen: (previous, current) =>
              previous.model.numbers != current.model.numbers,
          builder: (context, state) {
            final value = state.model.numbers;

            return Switch(
              value: value,
              activeColor: colorScheme.primary,
              onChanged: (bool value) {
                bloc.add(const ChangeNumbersEvent());
              },
            );
          },
        ),
      ],
    );
  }
}
