import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_bloc.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_event.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubmitTermsButtonWidget extends StatelessWidget {
  const SubmitTermsButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<SignUpBloc>();
    final appLocalizations = AppLocalizations.of(context)!;

    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          (previous.model.name != current.model.name),
      builder: (context, state) {
        final name = state.model.name;

        return AdsFilledButton(
          onPressedCallback: name.value.isEmpty
              ? null
              : () {
                  bloc.add(const OnSubmitFirstStep());
                },
          text: appLocalizations.signUpButtonText,
        );
      },
    );
  }
}
