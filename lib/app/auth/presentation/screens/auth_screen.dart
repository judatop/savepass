import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/auth/infrastructure/models/auth_type.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_bloc.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_event.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_state.dart';
import 'package:savepass/app/auth/presentation/widgets/already_have_account.dart';
import 'package:savepass/app/auth/presentation/widgets/auth_options.dart';
import 'package:savepass/app/auth/presentation/widgets/auth_terms.dart';
import 'package:savepass/app/auth/presentation/widgets/no_account.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:savepass/main.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabaseauth;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthScreen extends StatelessWidget {
  final AuthType authType;

  const AuthScreen({
    required this.authType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<AuthBloc>();
    return BlocProvider.value(
      value: bloc..add(AuthInitialEvent(authType: authType)),
      child: const BlocListener<AuthBloc, AuthState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  final intl = AppLocalizations.of(context)!;

  if (state is OpenSignInState) {
    Modular.to.popAndPushNamed(Routes.authRoute, arguments: AuthType.signIn);
  }

  if (state is OpenSignUpState) {
    Modular.to.popAndPushNamed(Routes.authRoute, arguments: AuthType.signUp);
  }

  if (state is OpenAuthScreenState) {
    Modular.to.pushNamedAndRemoveUntil(Routes.authInitRoute, (_) => false);
  }

  if (state is OpenSyncPassState) {
    Modular.to.pushNamedAndRemoveUntil(Routes.syncMasterPasswordRoute, (_) => false);
  }

  if (state is InvalidCredentialsState) {
    SnackBarUtils.showErrroSnackBar(context, intl.invalidCredentials);
  }

  if (state is UserAlreadyExistsState) {
    SnackBarUtils.showErrroSnackBar(context, intl.emailAlreadyInUse);
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  void initState() {
    _onAuthStateChange();
    super.initState();
  }

  void _onAuthStateChange() async {
    final bloc = Modular.get<AuthBloc>();
    supabase.auth.onAuthStateChange.listen(
      (data) {
        final supabaseauth.AuthChangeEvent event = data.event;
        final supabaseauth.Session? session = data.session;

        if (session == null) {
          return;
        }

        switch (event) {
          case supabaseauth.AuthChangeEvent.initialSession:
            break;
          case supabaseauth.AuthChangeEvent.signedIn:
            bloc.add(const ProcessSignedInEvent());
            break;
          case supabaseauth.AuthChangeEvent.signedOut:
            break;

          case supabaseauth.AuthChangeEvent.passwordRecovery:
            break;

          case supabaseauth.AuthChangeEvent.tokenRefreshed:
            break;

          case supabaseauth.AuthChangeEvent.userUpdated:
            break;

          case supabaseauth.AuthChangeEvent.userDeleted:
            break;

          case supabaseauth.AuthChangeEvent.mfaChallengeVerified:
            break;
        }
      },
    );
  }

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
        child: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (previous, current) =>
              (previous.model.status != current.model.status) ||
              (previous.model.authType != current.model.authType),
          builder: (context, state) {
            final authType = state.model.authType;

            return Stack(
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
                      child: Skeletonizer(
                        enabled: state.model.status.isInProgress,
                        child: Column(
                          children: [
                            Text(
                              '${authType == AuthType.signIn ? appLocalizations.getStartedSingIn : appLocalizations.getStartedSingUp} ${appLocalizations.authTitle}',
                              style: textTheme.headlineMedium?.copyWith(
                                fontSize: 26,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: deviceHeight * 0.03),
                            const AuthOptions(),
                            SizedBox(height: deviceHeight * 0.03),
                            if (authType == AuthType.signUp) const AuthTerms(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (authType == AuthType.signUp) const AlreadyHaveAccount(),
                if (authType == AuthType.signIn) const NoAccount(),
              ],
            );
          },
        ),
      ),
    );
  }
}
