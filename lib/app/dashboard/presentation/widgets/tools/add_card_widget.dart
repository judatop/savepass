import 'package:atomic_design_system/molecules/card/ads_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';

class AddCardWidget extends StatelessWidget {
  const AddCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final isLight = colorScheme.brightness == Brightness.light;

    return AdsCard(
      elevation: 1,
      onTap: () {
        final bloc = Modular.get<DashboardBloc>();
        bloc.add(const OnClickNewCard());
      },
      bgColor: isLight ? const Color(0xFFE8E8E8) : Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: deviceHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const IconButton(
              onPressed: null,
              icon: Icon(Icons.credit_card),
              iconSize: 30,
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  CircleBorder(),
                ),
              ),
            ),
            SizedBox(height: deviceWidth * 0.02),
            Text(
              'Add card',
              style: textTheme.titleMedium?.copyWith(
                color: isLight ? Colors.black : Colors.white,
                fontSize: 19.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
