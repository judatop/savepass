import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/theme/domain/entities/theme_entity.dart';
import 'package:savepass/app/theme/presentation/blocs/theme_bloc.dart';
import 'package:savepass/app/theme/presentation/blocs/theme_event.dart';
import 'package:savepass/app/theme/presentation/blocs/theme_state.dart';

class ThemeSettingsWidget extends StatelessWidget {
  const ThemeSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<ThemeBloc>();

    return AdsCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AdsTitle(
              text: intl.theme,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            Text(intl.themeDesc),
            const SizedBox(height: 10),
            BlocBuilder<ThemeBloc, ThemeState>(
              buildWhen: (previous, current) =>
                  previous.model.theme.brightness !=
                  current.model.theme.brightness,
              builder: (context, state) {
                final type = state.model.theme.brightness;

                return SegmentedButton<BrightnessType>(
                  segments: const <ButtonSegment<BrightnessType>>[
                    ButtonSegment<BrightnessType>(
                      value: BrightnessType.system,
                      icon: Icon(
                        Icons.smartphone_outlined,
                      ),
                    ),
                    ButtonSegment<BrightnessType>(
                      value: BrightnessType.light,
                      icon: Icon(
                        Icons.wb_sunny_outlined,
                      ),
                    ),
                    ButtonSegment<BrightnessType>(
                      value: BrightnessType.dark,
                      icon: Icon(
                        Icons.dark_mode_outlined,
                      ),
                    ),
                  ],
                  selected: <BrightnessType>{type},
                  onSelectionChanged: (Set<BrightnessType> newSelection) {
                    bloc.add(
                      ToggleBrightnessEvent(
                        brightness: newSelection.first,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
