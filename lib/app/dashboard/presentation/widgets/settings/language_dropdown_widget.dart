import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:atomic_design_system/organisms/ads_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/preferences/presentation/blocs/preferences_bloc.dart';
import 'package:savepass/app/preferences/presentation/blocs/preferences_event.dart';
import 'package:savepass/app/preferences/presentation/blocs/preferences_state.dart';
import 'package:savepass/app/preferences/utils/preferences_utils.dart';
import 'package:savepass/l10n/app_localizations.dart';

class LanguageDropdownWidget extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  LanguageDropdownWidget({super.key});

  void _onSelectItem(Object? selectedItem) {
    if (selectedItem is String) {
      final bloc = Modular.get<PreferencesBloc>();
      bloc.add(
        ChangeLocaleEvent(
          locale: Locale(
            PreferencesUtils.getLanguageCode(selectedItem),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return BlocBuilder<PreferencesBloc, PreferencesState>(
      buildWhen: (previous, current) =>
          (previous.model.locale != current.model.locale),
      builder: (context, state) {
        final localeText =
            PreferencesUtils.getLanguageText(state.model.locale.toString());
        _controller.text = localeText;
        List<String> supportedLocales = AppLocalizations.supportedLocales
            .map((e) => PreferencesUtils.getLanguageText(e.toString()))
            .toList();

        return AdsFormField(
          formField: AdsDropdown(
            controller: _controller,
            dropdownKey: const Key('settings_language_textField'),
            errorText: null,
            suffixIcon: Icons.arrow_drop_down,
            onTapCallback: () {
              showAdsDropdownBottomSheet(
                context,
                supportedLocales,
                _onSelectItem,
                false,
                intl.chooseOption,
              );
            },
          ),
        );
      },
    );
  }
}
