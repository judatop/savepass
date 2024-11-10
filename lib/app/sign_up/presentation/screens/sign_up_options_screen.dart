import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_bloc.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_event.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_state.dart';
import 'package:savepass/app/sign_up/presentation/widgets/sign_up_options/already_have_account_widget.dart';
import 'package:savepass/app/sign_up/presentation/widgets/sign_up_options/sign_up_options_widget.dart';
import 'package:savepass/app/sign_up/presentation/widgets/sign_up_options/terms_widget.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SignUpOptionsScreen extends StatelessWidget {
  const SignUpOptionsScreen({super.key});

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

  if (state is OpenSignInState) {
    Modular.to.popAndPushNamed(Routes.signInRoute);
  }

  if (state is OpenPrivacyPolicyState) {
    Modular.to.pushNamed(Routes.privacyPolicyRoute);
  }

  if (state is OpenSignUpWithEmailState) {
    Modular.to.pushNamed(Routes.signUpEmailRoute);
  }

  if (state is OpenSyncPassState) {
    Modular.to.pushNamed(Routes.syncMasterPasswordRoute);
  }

  if (state is EmailAlreadyInUseState) {
    SnackBarUtils.showErrroSnackBar(context, intl.emailAlreadyInUse);
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final appLocalizations = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: true,
      child: AdsScreenTemplate(
        wrapScroll: false,
        safeAreaBottom: false,
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: deviceWidth *
                        ADSFoundationSizes.defaultHorizontalPadding,
                    right: deviceWidth *
                        ADSFoundationSizes.defaultHorizontalPadding,
                  ),
                  child: BlocBuilder<SignUpBloc, SignUpState>(
                    buildWhen: (previous, current) =>
                        (previous.model.status != current.model.status),
                    builder: (context, state) {
                      return Skeletonizer(
                        enabled: state.model.status.isInProgress,
                        child: Column(
                          children: [
                            Text(
                              appLocalizations.authTitle,
                              style: textTheme.headlineMedium?.copyWith(
                                fontSize: 26,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: deviceHeight * 0.03),
                            const SignUpOptionsWidget(),
                            SizedBox(height: deviceHeight * 0.03),
                            const TermsWidget(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const AlreadyHaveAccountWidget(),
          ],
        ),
      ),
    );
  }
}
