import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/splash/presentation/blocs/splash_bloc.dart';
import 'package:savepass/app/splash/presentation/blocs/splash_event.dart';
import 'package:savepass/app/splash/presentation/blocs/splash_state.dart';
import 'package:savepass/app/splash/utils/splash_utils.dart';
import 'package:savepass/app/theme/presentation/blocs/theme_bloc.dart';
import 'package:savepass/app/theme/presentation/blocs/theme_event.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/image/image_paths.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<SplashBloc>();
    return BlocProvider.value(
      value: bloc..add(const SplashInitialEvent()),
      child: const BlocListener<SplashBloc, SplashState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  if (state is OpenGetStartedState) {
    Modular.to.pushNamedAndRemoveUntil(Routes.getStartedRoute, (_) => false);
  }

  if (state is OpenAuthInitState) {
    Modular.to.pushNamedAndRemoveUntil(Routes.authInitRoute, (_) => false);
  }

  if (state is OpenSyncMasterPasswordState) {
    Modular.to
        .pushNamedAndRemoveUntil(Routes.syncMasterPasswordRoute, (_) => false);
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
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _initTheme();
    _timerSplash();
  }

  void _initTheme() {
    final themeBloc = Modular.get<ThemeBloc>();
    themeBloc.add(const GetThemeEvent());
  }

  void _timerSplash() {
    Future.delayed(
      const Duration(milliseconds: SplashUtils.splashDuration),
      () async {
        final bloc = Modular.get<SplashBloc>();
        bloc.add(const ManageRouteChangeEvent());
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ADSFoundationsColors.whiteColor,
      body: Center(
        child: Image.asset(
          ImagePaths.logoLightImage,
          width: screenWidth,
        ),
      ),
    );
  }
}
