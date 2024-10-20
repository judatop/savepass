import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_bloc.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_event.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_state.dart';
import 'package:savepass/app/sign_up/presentation/widgets/second_step/sign_up_avatar_widget.dart';
import 'package:savepass/app/sign_up/presentation/widgets/second_step/sign_up_email_widget.dart';
import 'package:savepass/app/sign_up/presentation/widgets/second_step/sign_up_master_password_widget.dart';
import 'package:savepass/app/sign_up/presentation/widgets/second_step/sign_up_name_widget.dart';
import 'package:savepass/app/sign_up/presentation/widgets/second_step/sign_up_submit_button_widget.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SecondStepScreen extends StatelessWidget {
  const SecondStepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<SignUpBloc>();
    return BlocProvider.value(
      value: bloc..add(const SignUpInitialEvent()),
      child: const BlocListener<SignUpBloc, SignUpState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  final intl = AppLocalizations.of(context)!;

  if (state is OpenHomeState) {
    Modular.to.pop();
    Modular.to.popAndPushNamed(Routes.homeRoute);
  }

  if (state is EmailAlreadyInUseState) {
    SnackBarUtils.showErrroSnackBar(context, intl.emailAlreadyInUse);
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
      child: BlocBuilder<SignUpBloc, SignUpState>(
        buildWhen: (previous, current) =>
            (previous.model.status != current.model.status),
        builder: (context, state) {
          return Skeletonizer(
            enabled: state.model.status.isInProgress,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SignUpAvatarWidget(),
                SizedBox(height: deviceHeight * 0.05),
                const SignUpNameWidget(),
                SizedBox(height: deviceHeight * 0.02),
                const SignUpEmailWidget(),
                SizedBox(height: deviceHeight * 0.02),
                const SignUpMasterPasswordWidget(),
                SizedBox(height: deviceHeight * 0.05),
                const SignUpSubmitButtonWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
