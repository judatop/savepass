import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_bloc.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_state.dart';
import 'package:savepass/app/sign_up/presentation/widgets/first_step_widget.dart';
import 'package:savepass/app/sign_up/presentation/widgets/name_terms_widget.dart';
import 'package:savepass/app/sign_up/presentation/widgets/submit_name_terms_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<SignUpBloc>();
    return BlocProvider.value(
      value: bloc,
      child: const BlocListener<SignUpBloc, SignUpState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return AdsScreenTemplate(
      wrapScroll: false,
      safeAreaBottom: false,
      goBack: true,
      child: Padding(
        padding: EdgeInsets.only(top: deviceHeight * 0.15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AdsTitle(
              text: 'Let\'s start with your name',
            ),
            SizedBox(height: deviceHeight * 0.04),
            const FirstStepWidget(),
            SizedBox(height: deviceHeight * 0.015),
            const SubmitNameTermsWidget(),
            SizedBox(height: deviceHeight * 0.04),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
              child: const NameTermsWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
