import 'package:atomic_design_system/molecules/card/ads_card.dart';
import 'package:atomic_design_system/molecules/text/ads_subtitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoPasswordsWidget extends StatelessWidget {
  const NoPasswordsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;
    final bloc = Modular.get<DashboardBloc>();
    final intl = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: deviceWidth * 0.08,
        vertical: deviceHeight * 0.01,
      ),
      child: AdsCard(
        onTap: () => bloc.add(const OnClickNewPassword()),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.05,
            vertical: deviceHeight * 0.02,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: deviceWidth * 0.55,
                    child: AdsSubtitle(
                      textAlign: TextAlign.left,
                      text: intl.noPasswordsCreatedTitle,
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.005,
                  ),
                  SizedBox(
                    width: deviceWidth * 0.5,
                    child: Text(
                      intl.noPasswordsCreatedText,
                      style: const TextStyle(
                        fontSize: 14.5,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.search_off_outlined,
                size: deviceHeight * 0.04,
                color: colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
