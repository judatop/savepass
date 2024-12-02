import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';

class AboutAppSettingsWidget extends StatelessWidget {
  const AboutAppSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AdsCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AdsTitle(
              text: 'About App',
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star_outlined),
                        SizedBox(width: 5),
                        Text('Rate It'),
                      ],
                    ),
                    Icon(Icons.arrow_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.feedback_outlined),
                        SizedBox(width: 5),
                        Text('Feedback'),
                      ],
                    ),
                    Icon(Icons.arrow_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'App Version: 1.0.0',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
