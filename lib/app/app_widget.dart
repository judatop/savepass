import 'package:atomic_design_system/foundations/ads_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/theme/domain/entities/theme_entity.dart';
import 'package:savepass/app/theme/presentation/blocs/theme_bloc.dart';
import 'package:savepass/app/theme/presentation/blocs/theme_state.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute(Routes.splashRoute);
    final bloc = Modular.get<ThemeBloc>();

    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          final model = state.model.theme;
          final brightnessType = model.brightness;

          Brightness finalBrightness;

          if (brightnessType == BrightnessType.system) {
            final brightness = MediaQuery.of(context).platformBrightness;
            finalBrightness = brightness;
          } else {
            finalBrightness = brightnessType == BrightnessType.light
                ? Brightness.light
                : Brightness.dark;
          }

          return MaterialApp.router(
            title: 'SavePass',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            theme: finalBrightness == Brightness.light
                ? ADSTheme.lightTheme
                : ADSTheme.darkTheme,
            routerConfig: Modular.routerConfig,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
