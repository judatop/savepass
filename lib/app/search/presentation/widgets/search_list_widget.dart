import 'package:atomic_design_system/molecules/text/ads_subtitle.dart';
import 'package:atomic_design_system/molecules/text/ads_title.dart';
import 'package:flutter/material.dart';

final mockItems = [
  1,
  2,
  3,
  4,
  5,
];

class SearchListWidget extends StatelessWidget {
  const SearchListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final deviceHeight = MediaQuery.of(context).size.height;

    return ListView.separated(
      itemCount: mockItems.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {},
          title: const AdsTitle(
            text: 'Hola',
            textAlign: TextAlign.start,
          ),
          subtitle: const Text(
            '3424 XXXX XXXX 1232',
            textAlign: TextAlign.start,
          ),
          trailing: const Icon(Icons.chevron_right),
          leading: Icon(
            Icons.credit_card,
            color: colorScheme.primary,
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: deviceHeight * 0.015,
        );
      },
    );
  }
}
