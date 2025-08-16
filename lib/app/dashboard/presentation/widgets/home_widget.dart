import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/dashboard/presentation/widgets/home/home_search_widget.dart';
import 'package:savepass/app/dashboard/presentation/widgets/home/last_cards_widget.dart';
import 'package:savepass/app/dashboard/presentation/widgets/home/last_passwords_widget.dart';
import 'package:savepass/l10n/app_localizations.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<DashboardBloc>();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: (ADSFoundationSizes.defaultVerticalPadding / 2) * deviceHeight,
          left: ADSFoundationSizes.defaultHorizontalPadding * deviceWidth,
          right: ADSFoundationSizes.defaultHorizontalPadding * deviceWidth,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () => bloc.add(const OpenSearchEvent()),
              child: const HomeSearchWidget(),
            ),
            SizedBox(
              height: deviceHeight * 0.03,
            ),
            Text(intl.tipDashboard),
            SizedBox(
              height: deviceHeight * 0.03,
            ),
            const LastPasswordsWidget(),
            SizedBox(
              height: deviceHeight * 0.05,
            ),
            const LastCardsWidget(),
          ],
        ),
      ),
    );
  }
}
