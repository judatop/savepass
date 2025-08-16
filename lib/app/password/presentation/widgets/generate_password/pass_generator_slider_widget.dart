import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_state.dart';
import 'package:savepass/l10n/app_localizations.dart';

class PassGeneratorSliderWidget extends StatelessWidget {
  const PassGeneratorSliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<PasswordBloc>();
    final deviceWidth = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final intl = AppLocalizations.of(context)!;

    return BlocBuilder<PasswordBloc, PasswordState>(
      buildWhen: (previous, current) =>
          (previous.model.sliderValue != current.model.sliderValue),
      builder: (context, state) {
        final value = state.model.sliderValue;
        return Column(
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    intl.lengthText,
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
            Row(
              children: [
                AdsSubtitle(text: value.toStringAsFixed(0)),
                SizedBox(
                  width: deviceWidth * 0.01,
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: colorScheme.primary,
                      inactiveTrackColor: colorScheme.primary.withOpacity(0.3),
                      thumbColor: colorScheme.primary,
                      overlayColor: colorScheme.primary.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: value,
                      onChanged: (value) {
                        bloc.add(ChangeSliderValueEvent(value: value));
                      },
                      onChangeEnd: (value) {
                        bloc.add(const GenerateRandomPasswordEvent());
                      },
                      min: 4,
                      max: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
