import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/auth_init/domain/datasources/auth_init_datasource.dart';
import 'package:savepass/app/auth_init/domain/repositories/auth_init_repository.dart';
import 'package:savepass/app/auth_init/infrastructure/datasources/supabase_auth_init_datasource.dart';
import 'package:savepass/app/auth_init/infrastructure/repositories/auth_init_repository_impl.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_bloc.dart';
import 'package:savepass/app/auth_init/presentation/screens/auth_init_screen.dart';
import 'package:savepass/app/get_started/presentation/blocs/get_started_bloc.dart';
import 'package:savepass/app/get_started/presentation/screens/get_started_screen.dart';
import 'package:savepass/app/home/presentation/screens/home_screen.dart';
import 'package:savepass/app/privacy_policy/presentation/screens/privacy_policy_screen.dart';
import 'package:savepass/app/profile/domain/datasources/profile_datasource.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/app/profile/infraestructure/datasources/supabase_profile_datasource.dart';
import 'package:savepass/app/profile/infraestructure/repositories_impl/profile_repository_impl.dart';
import 'package:savepass/app/sign_in/domain/datasources/sign_in_datasource.dart';
import 'package:savepass/app/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:savepass/app/sign_in/infrastructure/datasources/supabase_sign_in_datasource.dart';
import 'package:savepass/app/sign_in/infrastructure/repositories/sign_in_repository_impl.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_bloc.dart';
import 'package:savepass/app/sign_in/presentation/screens/sign_in_email_screen.dart';
import 'package:savepass/app/sign_in/presentation/screens/sign_in_screen.dart';
import 'package:savepass/app/sign_up/domain/datasources/sign_up_datasource.dart';
import 'package:savepass/app/sign_up/domain/repositories/sign_up_repository.dart';
import 'package:savepass/app/sign_up/infrastructure/datasources/supabase_sign_up_datasource.dart';
import 'package:savepass/app/sign_up/infrastructure/repositories/sign_up_repository_impl.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_bloc.dart';
import 'package:savepass/app/sign_up/presentation/screens/sign_up_options_screen.dart';
import 'package:savepass/app/sign_up/presentation/screens/sign_up_email_screen.dart';
import 'package:savepass/app/splash/presentation/blocs/splash_bloc.dart';
import 'package:savepass/app/splash/presentation/splash_screen.dart';
import 'package:savepass/app/sync_pass/presentation/blocs/sync_bloc.dart';
import 'package:savepass/app/sync_pass/presentation/screens/sync_pass_screen.dart';
import 'package:savepass/app/theme/domain/repositories/theme_repository.dart';
import 'package:savepass/app/theme/infrastructure/repositories_impl/theme_irepository.dart';
import 'package:savepass/app/theme/presentation/blocs/theme_bloc.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/global/domain/datasources/secret_datasource.dart';
import 'package:savepass/core/global/domain/repositories/secret_repository.dart';
import 'package:savepass/core/global/infrastructure/datasources/supabase_secret_datasource.dart';
import 'package:savepass/core/global/infrastructure/repositories/secret_repository_impl.dart';
import 'package:savepass/core/global/presentation/screens/photo_permission_screen.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(FlutterSecureStorage.new);
    i.addSingleton(ThemeBloc.new);
    i.addSingleton(Logger.new);
    i.addSingleton<SignUpRepository>(SignUpRepositoryImpl.new);
    i.addSingleton<SignUpDatasource>(SupabaseSignUpDatasource.new);
    i.addSingleton<SignInRepository>(SignInRepositoryImpl.new);
    i.addSingleton<SignInDatasource>(SupabaseSignInDatasource.new);
    i.addSingleton<ProfileRepository>(ProfileRepositoryImpl.new);
    i.addSingleton<ProfileDatasource>(SupabaseProfileDatasource.new);
    i.addSingleton<ThemeRepository>(ThemeIRepository.new);
    i.addSingleton<SecretDatasource>(SupabaseSecretDatasource.new);
    i.addSingleton<SecretRepository>(SecretRepositoryImpl.new);
    i.addSingleton<AuthInitDatasource>(SupabaseAuthInitDatasource.new);
    i.addSingleton<AuthInitRepository>(AuthInitRepositoryImpl.new);
    i.addSingleton(GetStartedBloc.new);
    i.addSingleton(SignUpBloc.new);
    i.addSingleton(SignInBloc.new);
    i.addSingleton(AuthInitBloc.new);
    i.addSingleton(SyncBloc.new);
    i.addSingleton(SplashBloc.new);
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
      child: (context) => const SyncPassScreen(),
    );
  }
}
