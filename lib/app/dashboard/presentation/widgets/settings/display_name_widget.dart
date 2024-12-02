import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:savepass/app/dashboard/presentation/widgets/settings/display_name_form_widget.dart';

class DisplayNameWidget extends StatelessWidget {
  const DisplayNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdsCard(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdsTitle(
              text: 'Display Name',
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            Text(
              'Optional: Your name will be displayed in the app',
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            DisplayNameFormWidget(),
          ],
        ),
      ),
    );
  }
}
