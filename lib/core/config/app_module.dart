import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:savepass/app/get_started/presentation/blocs/get_started_bloc.dart';
import 'package:savepass/app/get_started/presentation/screens/get_started_screen.dart';
import 'package:savepass/app/sign_in/presentation/screens/sign_in_screen.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_bloc.dart';
import 'package:savepass/app/sign_up/presentation/screens/sign_up_screen.dart';
import 'package:savepass/app/splash/presentation/splash_screen.dart';
import 'package:savepass/app/theme/domain/repositories/theme_repository.dart';
import 'package:savepass/app/theme/infraestructure/repositories_impl/theme_irepository.dart';
import 'package:savepass/app/theme/presentation/blocs/theme_bloc.dart';
import 'package:savepass/core/config/routes.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(FlutterSecureStorage.new);
    i.addSingleton(ThemeBloc.new);
    i.addSingleton<ThemeRepository>(ThemeIRepository.new);
    i.addSingleton(GetStartedBloc.new);
    i.addSingleton(SignUpBloc.new);
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
      Routes.singUpRoute,
      child: (context) => const SignUpScreen(),
    );
  }
}
