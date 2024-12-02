import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';

class DisplayNameFormWidget extends StatefulWidget {
  const DisplayNameFormWidget({super.key});

  @override
  State<DisplayNameFormWidget> createState() => _DisplayNameFormWidgetState();
}

class _DisplayNameFormWidgetState extends State<DisplayNameFormWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          (previous.model.displayName != current.model.displayName),
      builder: (context, state) {
        final model = state.model;
        final displayName = model.displayName.value;
        _controller.text = displayName;

        return AdsFormField(
          formField: AdsTextField(
            controller: _controller,
            key: const Key('settings_displayName_textField'),
            keyboardType: TextInputType.text,
            enableSuggestions: false,
            onChanged: (value) {
              final bloc = Modular.get<DashboardBloc>();
              bloc.add(ChangeDisplayNameEvent(displayName: value));
            },
            textInputAction: TextInputAction.next,
          ),
        );
      },
    );
  }
}
