import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:savepass/l10n/app_localizations.dart';

class HomeSearchWidget extends StatelessWidget {
  const HomeSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AdsTextFormField(
      hintText: intl.homeSearch,
      key: const Key('home_search_textField'),
      keyboardType: TextInputType.text,
      errorText: null,
      enableSuggestions: false,
      textInputAction: TextInputAction.done,
      suffixIcon: Icons.search,
      enabled: false,
    );
  }
}
