import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/auth/domain/datasources/auth_datasource.dart';
import 'package:savepass/app/auth/domain/repositories/auth_repository.dart';
import 'package:savepass/app/auth/infrastructure/datasources/supabase_auth_datasource.dart';
import 'package:savepass/app/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_bloc.dart';
import 'package:savepass/app/auth/presentation/screens/auth_email_screen.dart';
import 'package:savepass/app/auth/presentation/screens/auth_screen.dart';
import 'package:savepass/app/auth/presentation/screens/confirm_mail_sign_up_screen.dart';
import 'package:savepass/app/auth/presentation/screens/forgot_password_mail_screen.dart';
import 'package:savepass/app/auth/presentation/screens/password_recovery_screen.dart';
import 'package:savepass/app/auth/presentation/screens/recovery_email_sent_screen.dart';
import 'package:savepass/app/auth_init/domain/datasources/auth_init_datasource.dart';
import 'package:savepass/app/auth_init/domain/repositories/auth_init_repository.dart';
import 'package:savepass/app/auth_init/infrastructure/datasources/supabase_auth_init_datasource.dart';
import 'package:savepass/app/auth_init/infrastructure/repositories/auth_init_repository_impl.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_bloc.dart';
import 'package:savepass/app/auth_init/presentation/screens/auth_init_screen.dart';
import 'package:savepass/app/biometric/domain/datasources/biometric_datasource.dart';
import 'package:savepass/app/biometric/domain/repositories/biometric_repository.dart';
import 'package:savepass/app/biometric/infrastructure/repositories_impl/biometric_repository_impl.dart';
import 'package:savepass/app/biometric/presentation/blocs/biometric_bloc.dart';
import 'package:savepass/app/biometric/presentation/screens/biometric_screen.dart';
import 'package:savepass/app/card/domain/datasources/card_datasource.dart';
import 'package:savepass/app/card/domain/datasources/supabase_biometric_datasource.dart';
import 'package:savepass/app/card/domain/repositories/card_repository.dart';
import 'package:savepass/app/card/infrastructure/datasources/supabase_card_datasource.dart';
import 'package:savepass/app/card/infrastructure/repositories_impl/card_repository_impl.dart';
import 'package:savepass/app/card/presentation/blocs/card/card_bloc.dart';
import 'package:savepass/app/card/presentation/blocs/card_report/card_report_bloc.dart';
import 'package:savepass/app/card/presentation/screens/card_report_screen.dart';
import 'package:savepass/app/card/presentation/screens/card_screen.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/enroll/domain/datasources/enroll_datasource.dart';
import 'package:savepass/app/enroll/domain/repositories/enroll_repository.dart';
import 'package:savepass/app/enroll/infrastructure/datasources/supabase_enroll_datasource.dart';
import 'package:savepass/app/enroll/infrastructure/repositories/enroll_repository_impl.dart';
import 'package:savepass/app/enroll/presentation/blocs/enroll_bloc.dart';
import 'package:savepass/app/enroll/presentation/screens/enroll_screen.dart';
import 'package:savepass/app/get_started/presentation/blocs/get_started_bloc.dart';
import 'package:savepass/app/get_started/presentation/screens/get_started_screen.dart';
import 'package:savepass/app/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:savepass/app/master_password/domain/datasources/master_password_datasource.dart';
import 'package:savepass/app/master_password/domain/repositories/master_password_repository.dart';
import 'package:savepass/app/master_password/infrastructure/datasources/supabase_master_password_datasource.dart';
import 'package:savepass/app/master_password/infrastructure/repositories_impl/master_password_repository_impl.dart';
import 'package:savepass/app/master_password/presentation/blocs/master_password_bloc.dart';
import 'package:savepass/app/master_password/presentation/screens/master_password_screen.dart';
import 'package:savepass/app/password/domain/datasources/password_datasource.dart';
import 'package:savepass/app/password/domain/repositories/password_repository.dart';
import 'package:savepass/app/password/infrastructure/datasources/supabase_password_datasource.dart';
import 'package:savepass/app/password/infrastructure/repositories_impl/password_repository_impl.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password_report/password_report_bloc.dart';
import 'package:savepass/app/password/presentation/screens/password_report_screen.dart';
import 'package:savepass/app/password/presentation/screens/password_screen.dart';
import 'package:savepass/app/preferences/domain/datasources/parameters_datasource.dart';
import 'package:savepass/app/preferences/domain/datasources/preferences_datasource.dart';
import 'package:savepass/app/preferences/infrastructure/datasources/local_parameters_datasource.dart';
import 'package:savepass/app/preferences/infrastructure/datasources/supabase_parameters_datasource.dart';
import 'package:savepass/app/profile/domain/datasources/profile_datasource.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/app/profile/infraestructure/datasources/supabase_profile_datasource.dart';
import 'package:savepass/app/profile/infraestructure/repositories_impl/profile_repository_impl.dart';
import 'package:savepass/app/profile/presentation/blocs/experiencing_issues/experiencing_issues_bloc.dart';
import 'package:savepass/app/profile/presentation/blocs/new_app_version/new_app_version_bloc.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_bloc.dart';
import 'package:savepass/app/profile/presentation/screens/new_app_version_screen.dart';
import 'package:savepass/app/profile/presentation/screens/we_are_experiencing_issues_screen.dart';
import 'package:savepass/app/search/presentation/blocs/search_bloc.dart';
import 'package:savepass/app/search/presentation/screens/search_screen.dart';
import 'package:savepass/app/splash/presentation/blocs/splash_bloc.dart';
import 'package:savepass/app/splash/presentation/splash_screen.dart';
import 'package:savepass/app/sync_pass/presentation/blocs/sync_bloc.dart';
import 'package:savepass/app/sync_pass/presentation/screens/sync_pass_screen.dart';
import 'package:savepass/app/preferences/domain/repositories/preferences_repository.dart';
import 'package:savepass/app/preferences/infrastructure/repositories_impl/preferences_irepository.dart';
import 'package:savepass/app/preferences/presentation/blocs/preferences_bloc.dart';
import 'package:savepass/core/api/supabase_middleware.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/global/presentation/screens/photo_permission_screen.dart';
import 'package:savepass/core/utils/biometric_utils.dart';
import 'package:savepass/core/utils/device_info.dart';
import 'package:savepass/core/utils/security_utils.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(FlutterSecureStorage.new);
    i.addSingleton(PreferencesBloc.new);
    i.addSingleton<Logger>(() => Logger('SavePassLogger'));
    i.addSingleton(SupabaseMiddleware.new);
    i.addSingleton(SecurityUtils.new);
    i.addSingleton(BiometricUtils.new);
    i.addSingleton(LocalAuthentication.new);
    i.addSingleton(DeviceInfo.new);
    i.addSingleton<ProfileRepository>(ProfileRepositoryImpl.new);
    i.addSingleton<ProfileDatasource>(SupabaseProfileDatasource.new);
    i.addSingleton<PreferencesRepository>(PreferencesIRepository.new);
    i.addSingleton<PreferencesDatasource>(LocalPreferencesDatasource.new);
    i.addSingleton<ParametersDatasource>(SupabaseParametersDatasource.new);
    i.addSingleton<AuthInitDatasource>(SupabaseAuthInitDatasource.new);
    i.addSingleton<AuthInitRepository>(AuthInitRepositoryImpl.new);
    i.addSingleton<AuthDatasource>(SupabaseAuthDatasource.new);
    i.addSingleton<AuthRepository>(AuthRepositoryImpl.new);
    i.addSingleton<PasswordDatasource>(SupabasePasswordDatasource.new);
    i.addSingleton<PasswordRepository>(PasswordRepositoryImpl.new);
    i.addSingleton<CardDatasource>(SupabaseCardDatasource.new);
    i.addSingleton<CardRepository>(CardRepositoryImpl.new);
    i.addSingleton<EnrollDatasource>(SupabaseEnrollDatasource.new);
    i.addSingleton<EnrollRepository>(EnrollRepositoryImpl.new);
    i.addSingleton<BiometricDatasource>(SupabaseBiometricDatasource.new);
    i.addSingleton<BiometricRepository>(BiometricRepositoryImpl.new);
    i.addSingleton<MasterPasswordDatasource>(
      SupabaseMasterPasswordDatasource.new,
    );
    i.addSingleton<MasterPasswordRepository>(MasterPasswordRepositoryImpl.new);
    i.addSingleton(GetStartedBloc.new);
    i.addSingleton(AuthInitBloc.new);
    i.addSingleton(SyncBloc.new);
    i.addSingleton(SplashBloc.new);
    i.addSingleton(AuthBloc.new);
    i.addSingleton(DashboardBloc.new);
    i.addSingleton(PasswordBloc.new);
    i.addSingleton(CardBloc.new);
    i.addSingleton(SearchBloc.new);
    i.addSingleton(PassReportBloc.new);
    i.addSingleton(CardReportBloc.new);
    i.addSingleton(EnrollBloc.new);
    i.addSingleton(ProfileBloc.new);
    i.addSingleton(BiometricBloc.new);
    i.addSingleton(MasterPasswordBloc.new);
    i.addSingleton(ExperiencingIssuesBloc.new);
    i.addSingleton(NewAppVersionBloc.new);
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
      Routes.dashboardRoute,
      child: (context) => const DashboardScreen(),
    );
    r.child(
      Routes.authInitRoute,
      child: (context) => AuthInitScreen(
        refreshAuth: r.args.data,
      ),
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
      Routes.forgotPasswordRoute,
      child: (context) => const ForgotPasswordMailScreen(),
    );
    r.child(
      Routes.passwordRoute,
      child: (context) => PasswordScreen(selectedPassId: r.args.data),
    );
    r.child(
      Routes.cardRoute,
      child: (context) => CardScreen(selectedCardId: r.args.data),
    );
    r.child(
      Routes.searchRoute,
      child: (context) => const SearchScreen(),
    );
    r.child(
      Routes.passwordReport,
      child: (context) => const PasswordReportScreen(),
    );
    r.child(
      Routes.cardReport,
      child: (context) => const CardReportScreen(),
    );
    r.child(
      Routes.enrollRoute,
      child: (context) => const EnrollScreen(),
    );
    r.child(
      Routes.biometricRoute,
      child: (context) => const BiometricScreen(),
    );
    r.child(
      Routes.masterPasswordRoute,
      child: (context) => const MasterPasswordScreen(),
    );
    r.child(
      Routes.emailSentRoute,
      child: (context) => const RecoveryEmailSentScreen(),
    );
    r.child(
      Routes.recoveryPasswordRoute,
      child: (context) => const PasswordRecoveryScreen(),
    );
    r.child(
      Routes.signUpConfirmMail,
      child: (context) => const ConfirmMailSignUpScreen(),
    );
    r.child(
      Routes.weAreExperiencingIssuesRoute,
      child: (context) => const WeAreExperiencingIssuesScreen(),
    );
    r.child(
      Routes.newAppVersionRoute,
      child: (context) => const NewAppVersionScreen(),
    );
  }
}
