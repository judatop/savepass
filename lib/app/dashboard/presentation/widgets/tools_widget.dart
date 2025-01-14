import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/core/utils/auth_utils.dart';

class ToolsWidget extends StatelessWidget {
  const ToolsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          flex: 9,
          child: Padding(
            padding: EdgeInsets.only(
              left: deviceWidth * 0.04,
              right: deviceWidth * 0.04,
              top: deviceHeight * 0.02,
              bottom: deviceHeight * 0.01,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 6,
                        child: AdsCard(
                          bgColor: theme.primaryColor,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: deviceHeight * 0.02,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Passwords',
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.01),
                      const Expanded(
                        flex: 4,
                        child: AdsCard(
                          bgColor: Color(0xFFE8E8E8),
                          child: Row(
                            children: [AdsTitle(text: 'Hey')],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: deviceWidth * 0.015),
                Expanded(
                  child: Column(
                    children: [
                      const Expanded(
                        flex: 5,
                        child: AdsCard(
                          bgColor: Color(0xFFE8E8E8),
                          child: Row(
                            children: [AdsTitle(text: 'Hey')],
                          ),
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.01),
                      const Expanded(
                        flex: 6,
                        child: AdsCard(
                          bgColor: Color(0xFFE8E8E8),
                          child: Row(
                            children: [AdsTitle(text: 'Hey')],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(
              left: deviceWidth * 0.04,
              right: deviceWidth * 0.04,
              bottom: deviceHeight * 0.02,
            ),
            child: AdsCard(
              onTap: () {},
              bgColor: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.face,
                    color: Colors.white,
                  ),
                  SizedBox(width: deviceWidth * 0.02),
                  Text(
                    'Use biometrics',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
