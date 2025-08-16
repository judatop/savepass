import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:savepass/core/utils/regex_utils.dart';

class DisplayNameFormWidget extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  DisplayNameFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<DashboardBloc>();

    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          (previous.model.displayName != current.model.displayName),
      builder: (context, state) {
        final displayName = state.model.displayName.value;
        _controller.text = displayName;

        return AdsTextField(
          controller: _controller,
          hintText: intl.optionalForm,
          key: const Key('settings_displayName_textField'),
          keyboardType: TextInputType.text,
          errorText: null,
          enableSuggestions: false,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegexUtils.numbersAndLettersWithSpace,
            ),
          ],
          onChanged: (value) {
            bloc.add(ChangeDisplayNameEvent(displayName: value));
          },
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}
