import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/auth/domain/datasources/auth_datasource.dart';
import 'package:savepass/app/auth/domain/repositories/auth_repository.dart';
import 'package:savepass/app/auth/infrastructure/datasources/supabase_auth_datasource.dart';
import 'package:savepass/app/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_bloc.dart';
import 'package:savepass/app/auth/presentation/screens/auth_email_screen.dart';
import 'package:savepass/app/auth/presentation/screens/auth_screen.dart';
import 'package:savepass/app/auth_init/domain/datasources/auth_init_datasource.dart';
import 'package:savepass/app/auth_init/domain/repositories/auth_init_repository.dart';
import 'package:savepass/app/auth_init/infrastructure/datasources/supabase_auth_init_datasource.dart';
import 'package:savepass/app/auth_init/infrastructure/repositories/auth_init_repository_impl.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_bloc.dart';
import 'package:savepass/app/auth_init/presentation/screens/auth_init_screen.dart';
import 'package:savepass/app/card/domain/datasources/card_datasource.dart';
import 'package:savepass/app/card/domain/repositories/card_repository.dart';
import 'package:savepass/app/card/infrastructure/datasources/supabase_card_datasource.dart';
import 'package:savepass/app/card/infrastructure/repositories_impl/card_repository_impl.dart';
import 'package:savepass/app/card/presentation/blocs/card_bloc.dart';
import 'package:savepass/app/card/presentation/screens/card_screen.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/get_started/presentation/blocs/get_started_bloc.dart';
import 'package:savepass/app/get_started/presentation/screens/get_started_screen.dart';
import 'package:savepass/app/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:savepass/app/password/domain/datasources/password_datasource.dart';
import 'package:savepass/app/password/domain/repositories/password_repository.dart';
import 'package:savepass/app/password/infrastructure/datasources/supabase_password_datasource.dart';
import 'package:savepass/app/password/infrastructure/repositories_impl/password_repository_impl.dart';
import 'package:savepass/app/password/presentation/blocs/password_bloc.dart';
import 'package:savepass/app/password/presentation/screens/password_screen.dart';
import 'package:savepass/app/preferences/domain/datasources/parameters_datasource.dart';
import 'package:savepass/app/preferences/domain/datasources/preferences_datasource.dart';
import 'package:savepass/app/preferences/infrastructure/datasources/local_parameters_datasource.dart';
import 'package:savepass/app/preferences/infrastructure/datasources/supabase_parameters_datasource.dart';
import 'package:savepass/app/privacy_policy/presentation/screens/privacy_policy_screen.dart';
import 'package:savepass/app/profile/domain/datasources/profile_datasource.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/app/profile/infraestructure/datasources/supabase_profile_datasource.dart';
import 'package:savepass/app/profile/infraestructure/repositories_impl/profile_repository_impl.dart';
import 'package:savepass/app/search/presentation/blocs/search_bloc.dart';
import 'package:savepass/app/search/presentation/screens/search_screen.dart';
import 'package:savepass/app/splash/presentation/blocs/splash_bloc.dart';
import 'package:savepass/app/splash/presentation/splash_screen.dart';
import 'package:savepass/app/sync_pass/presentation/blocs/sync_bloc.dart';
import 'package:savepass/app/sync_pass/presentation/screens/sync_pass_screen.dart';
import 'package:savepass/app/preferences/domain/repositories/preferences_repository.dart';
import 'package:savepass/app/preferences/infrastructure/repositories_impl/preferences_irepository.dart';
import 'package:savepass/app/preferences/presentation/blocs/preferences_bloc.dart';
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
    i.addSingleton(PreferencesBloc.new);
    i.addSingleton(Logger.new);
    i.addSingleton<ProfileRepository>(ProfileRepositoryImpl.new);
    i.addSingleton<ProfileDatasource>(SupabaseProfileDatasource.new);
    i.addSingleton<PreferencesRepository>(PreferencesIRepository.new);
    i.addSingleton<PreferencesDatasource>(LocalPreferencesDatasource.new);
    i.addSingleton<ParametersDatasource>(SupabaseParametersDatasource.new);
    i.addSingleton<SecretDatasource>(SupabaseSecretDatasource.new);
    i.addSingleton<SecretRepository>(SecretRepositoryImpl.new);
    i.addSingleton<AuthInitDatasource>(SupabaseAuthInitDatasource.new);
    i.addSingleton<AuthInitRepository>(AuthInitRepositoryImpl.new);
    i.addSingleton<AuthDatasource>(SupabaseAuthDatasource.new);
    i.addSingleton<AuthRepository>(AuthRepositoryImpl.new);
    i.addSingleton<PasswordDatasource>(SupabasePasswordDatasource.new);
    i.addSingleton<PasswordRepository>(PasswordRepositoryImpl.new);
    i.addSingleton<CardDatasource>(SupabaseCardDatasource.new);
    i.addSingleton<CardRepository>(CardRepositoryImpl.new);
    i.addSingleton(GetStartedBloc.new);
    i.addSingleton(AuthInitBloc.new);
    i.addSingleton(SyncBloc.new);
    i.addSingleton(SplashBloc.new);
    i.addSingleton(AuthBloc.new);
    i.addSingleton(DashboardBloc.new);
    i.addSingleton(PasswordBloc.new);
    i.addSingleton(CardBloc.new);
    i.addSingleton(SearchBloc.new);
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
      Routes.privacyPolicyRoute,
      child: (context) => const PrivacyPolicyScreen(),
    );
    r.child(
      Routes.dashboardRoute,
      child: (context) => const DashboardScreen(),
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
    r.child(
      Routes.authRoute,
      child: (context) => AuthScreen(authType: r.args.data),
    );
    r.child(
      Routes.authEmailRoute,
      child: (context) => const AuthEmailScreen(),
    );
    r.child(
      Routes.passwordRoute,
      child: (context) => PasswordScreen(selectedPassId: r.args.data),
    );
    r.child(
      Routes.cardRoute,
      child: (context) => CardScreen(cardId: r.args.data),
    );
    r.child(
      Routes.searchRoute,
      child: (context) => const SearchScreen(),
    );
  }
}
