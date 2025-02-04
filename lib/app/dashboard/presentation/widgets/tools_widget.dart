import 'dart:io';

import 'package:flutter/material.dart';
import 'package:savepass/app/dashboard/presentation/widgets/tools/add_card_widget.dart';
import 'package:savepass/app/dashboard/presentation/widgets/tools/add_password_widget.dart';
import 'package:savepass/app/dashboard/presentation/widgets/tools/cards_widget.dart';
import 'package:savepass/app/dashboard/presentation/widgets/tools/join_biometrics_widget.dart';
import 'package:savepass/app/dashboard/presentation/widgets/tools/passwords_widget.dart';

class ToolsWidget extends StatelessWidget {
  const ToolsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Expanded(
          flex: 9,
          child: Padding(
            padding: EdgeInsets.only(
              left: deviceWidth * 0.04,
              right: deviceWidth * 0.04,
              top: deviceHeight * (Platform.isAndroid ? 0.04 : 0.02),
              bottom: deviceHeight * 0.01,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Expanded(
                        flex: 6,
                        child: PasswordsWidget(),
                      ),
                      SizedBox(height: deviceHeight * 0.01),
                      const Expanded(
                        flex: 4,
                        child: AddCardWidget(),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: deviceWidth * 0.015),
                Expanded(
                  child: Column(
                    children: [
                      const Expanded(
                        flex: 4,
                        child: AddPasswordWidget(),
                      ),
                      SizedBox(height: deviceHeight * 0.01),
                      const Expanded(
                        flex: 5,
                        child: CardsWidget(),
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
            child: Container(),
            // child: const JoinBiometricsWidget(),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
