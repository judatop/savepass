import 'package:atomic_design_system/foundations/ads_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/theme/presentation/blocs/theme_bloc.dart';
import 'package:savepass/app/theme/presentation/blocs/theme_state.dart';
import 'package:savepass/core/config/routes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute(Routes.signInRoute);
    final bloc = Modular.get<ThemeBloc>();

    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          // final model = state.model.theme;
          // final brightnessType = model.brightness;
          return MaterialApp.router(
            title: 'SavePass',
            theme: ADSTheme.lightTheme,
            routerConfig: Modular.routerConfig,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
