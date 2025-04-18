import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/app/preferences/presentation/blocs/preferences_bloc.dart';
import 'package:savepass/app/preferences/presentation/blocs/preferences_state.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppSettingsWidget extends StatelessWidget {
  const AboutAppSettingsWidget({super.key});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'app.savepass@gmail.com',
      queryParameters: {
        'subject': 'Support',
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw Exception('Error launching mail URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AdsCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AdsTitle(
              text: intl.aboutTitle,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_outlined),
                        const SizedBox(width: 10),
                        Text(intl.rateIt),
                      ],
                    ),
                    const Icon(Icons.arrow_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: _launchEmail,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.report),
                        const SizedBox(width: 10),
                        Text(intl.support),
                      ],
                    ),
                    const Icon(Icons.arrow_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            BlocBuilder<PreferencesBloc, PreferencesState>(
              buildWhen: (previous, current) =>
                  previous.model.appVersion != current.model.appVersion,
              builder: (context, state) {
                final appVersion = state.model.appVersion;

                return Text(
                  '${intl.appVersion}${appVersion.isNotEmpty ? ': $appVersion' : ''}',
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
