import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/search/presentation/widgets/search_widget.dart';

class SearchHeaderWidget extends StatelessWidget {
  const SearchHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height:
              (ADSFoundationSizes.defaultVerticalPadding / 2) * screenHeight,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AdsFilledRoundIconButton(
              icon: const Icon(
                Icons.keyboard_arrow_left,
              ),
              onPressedCallback: () {
                Modular.to.pop();
              },
            ),
            SizedBox(
              width: screenWidth * 0.02,
            ),
            const Flexible(child:  SearchWidget()),
          ],
        ),
      ],
    );
  }
}
