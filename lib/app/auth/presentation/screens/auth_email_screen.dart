import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/auth/infrastructure/models/auth_type.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_bloc.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/app/auth/presentation/widgets/auth_email.dart';
import 'package:savepass/app/auth/presentation/widgets/auth_header_widget.dart';
import 'package:savepass/app/auth/presentation/widgets/auth_sign_in_password.dart';
import 'package:savepass/app/auth/presentation/widgets/auth_sign_up_password.dart';
import 'package:savepass/app/auth/presentation/widgets/auth_submit.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AuthEmailScreen extends StatelessWidget {
  const AuthEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<AuthBloc>();

    return BlocProvider.value(
      value: bloc,
      child: const BlocListener<AuthBloc, AuthState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  final intl = AppLocalizations.of(context)!;

  if (state is EmailAlreadyUsedState) {
    SnackBarUtils.showErrroSnackBar(
      context,
      intl.emailAlreadyInUse,
    );
  }

  if (state is GeneralErrorState) {
    SnackBarUtils.showErrroSnackBar(
      context,
      intl.genericError,
    );
  }

  if (state is OpenSyncPassState) {
    Modular.to
        .pushNamedAndRemoveUntil(Routes.syncMasterPasswordRoute, (_) => false);
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return AdsScreenTemplate(
      goBack: false,
      wrapScroll: true,
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) =>
            (previous.model.status != current.model.status),
        builder: (context, state) {
          final authType = state.model.authType;

          return Skeletonizer(
            enabled: state.model.status.isInProgress,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthHeaderWidget(),
                SizedBox(height: deviceHeight * 0.06),
                const AuthEmail(),
                SizedBox(height: deviceHeight * 0.02),
                if (authType == AuthType.signUp) const AuthSignUpPassword(),
                if (authType == AuthType.signIn) const AuthSignInPassword(),
                SizedBox(height: deviceHeight * 0.05),
                const AuthSubmit(),
              ],
            ),
          );
        },
      ),
    );
  }
}
