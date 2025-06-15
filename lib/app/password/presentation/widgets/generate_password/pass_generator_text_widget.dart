import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_state.dart';

class PassGeneratorTextWidget extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  PassGeneratorTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordBloc, PasswordState>(
      buildWhen: (previous, current) =>
          (previous.model.generatedPassword.value !=
              current.model.generatedPassword.value),
      builder: (context, state) {
        final model = state.model;
        final generatedPassword = model.singleTag.value;

        _controller.text = generatedPassword;

        return AdsTextField(
          controller: _controller,
          key: const Key('password_generator_textField'),
          keyboardType: TextInputType.text,
          enableSuggestions: false,
          textInputAction: TextInputAction.next,
          enabled: false,
        );
      },
    );
  }
}
