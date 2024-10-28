import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_bloc.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_state.dart';
import 'package:savepass/app/sign_up/presentation/widgets/sign_up_email/sign_up_master_password_widget.dart';
import 'package:savepass/app/sign_up/presentation/widgets/sign_up_sync_password/submit_sync_password_widget.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpSyncMasterPasswordScreen extends StatelessWidget {
  const SignUpSyncMasterPasswordScreen({super.key});

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

void _listener(context, state) {
  if (state is OpenHomeState) {
    Modular.to.pushNamedAndRemoveUntil(Routes.homeRoute, (route) => false);
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final intl = AppLocalizations.of(context)!;

    return AdsScreenTemplate(
      wrapScroll: false,
      child: PopScope(
        canPop: false,
        child: BlocBuilder<SignUpBloc, SignUpState>(
          buildWhen: (previous, current) =>
              (previous.model.status != current.model.status),
          builder: (context, state) {
            return Skeletonizer(
              enabled: state.model.status.isInProgress,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AdsHeadline(text: intl.actionNeeded),
                  SizedBox(height: deviceHeight * 0.05),
                  const SignUpMasterPasswordWidget(),
                  SizedBox(height: deviceHeight * 0.02),
                  const SubmitSyncPasswordWidget(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
