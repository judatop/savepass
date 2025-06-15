import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_state.dart';

class PassGeneratorTextWidget extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  PassGeneratorTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<PasswordBloc>();
    final deviceWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<PasswordBloc, PasswordState>(
      buildWhen: (previous, current) =>
          (previous.model.generatedPassword.value !=
              current.model.generatedPassword.value),
      builder: (context, state) {
        final model = state.model;
        final generatedPassword = model.generatedPassword.value;

        _controller.text = generatedPassword;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: AdsTextField(
                controller: _controller,
                key: const Key('password_generator_textField'),
                keyboardType: TextInputType.text,
                enableSuggestions: false,
                textInputAction: TextInputAction.next,
                enabled: false,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: deviceWidth * 0.03,
            ),
            AdsFilledRoundIconButton(
              icon: const Icon(Icons.refresh),
              onPressedCallback: () =>
                  bloc.add(const GenerateRandomPasswordEvent()),
            ),
          ],
        );
      },
    );
  }
}
