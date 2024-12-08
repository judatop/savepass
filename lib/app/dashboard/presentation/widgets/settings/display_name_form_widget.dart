import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/core/utils/regex_utils.dart';

class DisplayNameFormWidget extends StatefulWidget {
  const DisplayNameFormWidget({super.key});

  @override
  State<DisplayNameFormWidget> createState() => _DisplayNameFormWidgetState();
}

class _DisplayNameFormWidgetState extends State<DisplayNameFormWidget> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  @override
  void initState() {
    _focusNode = FocusNode();
    _controller = TextEditingController();
    _focusNode.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    final text = _controller.text;

    if (!_focusNode.hasFocus && text.isNotEmpty) {
      final bloc = Modular.get<DashboardBloc>();
      bloc.add(ChangeDisplayNameEvent(displayName: _controller.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          (previous.model.displayName != current.model.displayName),
      builder: (context, state) {
        final displayName = state.model.displayName;
        _controller.text = displayName;

        return AdsFormField(
          formField: AdsTextField(
            focusNode: _focusNode,
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
            textInputAction: TextInputAction.done,
          ),
        );
      },
    );
  }
}
