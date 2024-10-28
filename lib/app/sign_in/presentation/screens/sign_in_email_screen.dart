import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_bloc.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_event.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_state.dart';
import 'package:savepass/app/sign_in/presentation/widgets/sign_in_email_widget.dart';
import 'package:savepass/app/sign_in/presentation/widgets/sign_in_password_widget.dart';
import 'package:savepass/app/sign_in/presentation/widgets/sign_in_submit_button_widget.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInEmailScreen extends StatelessWidget {
  const SignInEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<SignInBloc>();
    return BlocProvider.value(
      value: bloc..add(const SignInInitialEvent()),
      child: const BlocListener<SignInBloc, SignInState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  final intl = AppLocalizations.of(context)!;

  if (state is OpenHomeState) {
    Modular.to.pushNamedAndRemoveUntil(Routes.homeRoute, (route) => false);
  }

  if (state is InvalidCredentialsState) {
    SnackBarUtils.showErrroSnackBar(context, intl.invalidCredentials);
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return AdsScreenTemplate(
      goBack: true,
      wrapScroll: true,
      child: BlocBuilder<SignInBloc, SignInState>(
        buildWhen: (previous, current) =>
            (previous.model.status != current.model.status),
        builder: (context, state) {
          return Skeletonizer(
            enabled: state.model.status.isInProgress,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SignInEmailWidget(),
                SizedBox(height: deviceHeight * 0.02),
                const SignInPasswordWidget(),
                SizedBox(height: deviceHeight * 0.05),
                const SignInSubmitButtonWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
