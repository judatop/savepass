import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_bloc.dart';
import 'package:savepass/app/auth_init/presentation/screens/auth_init_screen.dart';
import 'package:savepass/app/get_started/presentation/blocs/get_started_bloc.dart';
import 'package:savepass/app/get_started/presentation/screens/get_started_screen.dart';
import 'package:savepass/app/home/presentation/screens/home_screen.dart';
import 'package:savepass/app/privacy_policy/presentation/screens/privacy_policy_screen.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_bloc.dart';
import 'package:savepass/app/sign_in/presentation/screens/sign_in_email_screen.dart';
import 'package:savepass/app/sign_in/presentation/screens/sign_in_screen.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_bloc.dart';
import 'package:savepass/app/sign_up/presentation/screens/sign_up_sync_master_password_screen.dart';
import 'package:savepass/app/sign_up/presentation/screens/sign_up_options_screen.dart';
import 'package:savepass/app/sign_up/presentation/screens/sign_up_email_screen.dart';
import 'package:savepass/app/splash/presentation/splash_screen.dart';
import 'package:savepass/app/theme/domain/repositories/theme_repository.dart';
import 'package:savepass/app/theme/infrastructure/repositories_impl/theme_irepository.dart';
import 'package:savepass/app/theme/presentation/blocs/theme_bloc.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/screens/photo_permission_screen.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(FlutterSecureStorage.new);
    i.addSingleton(ThemeBloc.new);
    i.addSingleton<ThemeRepository>(ThemeIRepository.new);
    i.addSingleton(GetStartedBloc.new);
    i.addSingleton(SignUpBloc.new);
    i.addSingleton(SignInBloc.new);
    i.addSingleton(AuthInitBloc.new);
  }

  @override
  void routes(r) {
    r.child(
      Routes.splashRoute,
      child: (context) => const SplashScreen(),
    );
    r.child(
      Routes.getStartedRoute,
      child: (context) => const GetStartedScreen(),
    );
    r.child(
      Routes.signInRoute,
      child: (context) => const SignInScreen(),
    );
    r.child(
      Routes.signInEmail,
      child: (context) => const SignInEmailScreen(),
    );
    r.child(
      Routes.signUpOptionsRoute,
      child: (context) => const SignUpOptionsScreen(),
    );
    r.child(
      Routes.signUpEmailRoute,
      child: (context) => const SignUpEmailScreen(),
    );
    r.child(
      Routes.privacyPolicyRoute,
      child: (context) => const PrivacyPolicyScreen(),
    );
    r.child(
      Routes.homeRoute,
      child: (context) => const HomeScreen(),
    );
    r.child(
      Routes.authInitRoute,
      child: (context) => const AuthInitScreen(),
    );
    r.child(
      Routes.photoPermissionRoute,
      child: (context) => PhotoPermissionScreen(callbackIfSuccess: r.args.data),
    );
    r.child(
      Routes.syncMasterPasswordRoute,
      child: (context) => const SignUpSyncMasterPasswordScreen(),
    );
  }
}
