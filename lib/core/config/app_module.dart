import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:savepass/app/sign_in/presentation/sign_in_screen.dart';
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
  }

  @override
  void routes(r) {
    r.child(
      Routes.splashRoute,
      child: (context) => const SplashScreen(),
    );
    r.child(
      Routes.signInRoute,
      child: (context) => const SignInScreen(),
    );
  }
}
