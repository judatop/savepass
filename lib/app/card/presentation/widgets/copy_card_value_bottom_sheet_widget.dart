import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/card/infrastructure/models/dashboard_card_model.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CopyCardValueBottomSheetWidget extends StatelessWidget {
  final FormzSubmissionStatus status;
  final DashboardCardModel card;

  const CopyCardValueBottomSheetWidget({
    super.key,
    required this.status,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final bloc = Modular.get<DashboardBloc>();
    final intl = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Positioned(
          top: deviceHeight * 0.01,
          right: deviceWidth * 0.04,
          child: Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () => Modular.to.pop(),
              child: Text(
                intl.close,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.04,
            vertical: deviceHeight * 0.08,
          ),
          child: SingleChildScrollView(
            child: Skeletonizer(
              enabled: status.isInProgress,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: deviceHeight * 0.01,
                  ),
                  Text(
                    intl.copyValueCardTooltip,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.03,
                  ),
                  ListTile(
                    onTap: () {
                      Modular.to.pop();
                      bloc.add(
                        GetCardValueEvent(
                          vaultId: card.vaultId,
                          index: 1,
                        ),
                      );
                    },
                    title: Text(
                      intl.cardNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    leading: const Icon(
                      Icons.numbers,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      Modular.to.pop();
                      bloc.add(
                        GetCardValueEvent(
                          vaultId: card.vaultId,
                          index: 2,
                        ),
                      );
                    },
                    title: Text(
                      intl.cardholderName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    leading: const Icon(
                      Icons.person,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      Modular.to.pop();
                      bloc.add(
                        GetCardValueEvent(
                          vaultId: card.vaultId,
                          index: 3,
                        ),
                      );
                    },
                    title: Text(
                      intl.cardExpiration,
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    leading: const Icon(
                      Icons.date_range,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      Modular.to.pop();
                      bloc.add(
                        GetCardValueEvent(
                          vaultId: card.vaultId,
                          index: 4,
                        ),
                      );
                    },
                    title: Text(
                      intl.cardCvv,
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    leading: const Icon(
                      Icons.security,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
