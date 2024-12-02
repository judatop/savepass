import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';

enum Calendar { system, light, dark }

class ThemeSettingsWidget extends StatelessWidget {
  const ThemeSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Calendar calendarView = Calendar.light;

    return AdsCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AdsTitle(
              text: 'Theme',
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            const Text('Choose your preferred theme'),
            const SizedBox(height: 10),
            SegmentedButton<Calendar>(
              segments: const <ButtonSegment<Calendar>>[
                ButtonSegment<Calendar>(
                  value: Calendar.system,
                  icon: Icon(Icons.smartphone_outlined),
                ),
                ButtonSegment<Calendar>(
                  value: Calendar.light,
                  icon: Icon(Icons.wb_sunny_outlined),
                ),
                ButtonSegment<Calendar>(
                  value: Calendar.dark,
                  icon: Icon(Icons.dark_mode_outlined),
                ),
              ],
              selected: <Calendar>{calendarView},
              onSelectionChanged: (Set<Calendar> newSelection) {},
            ),
          ],
        ),
      ),
    );
  }
}
