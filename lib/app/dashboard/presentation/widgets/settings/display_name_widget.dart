import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:savepass/app/dashboard/presentation/widgets/settings/display_name_form_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DisplayNameWidget extends StatelessWidget {
  const DisplayNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<DashboardBloc>();
    final intl = AppLocalizations.of(context)!;

    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          (previous.model.displayNameStatus != current.model.displayNameStatus),
      builder: (context, state) {
        return Skeletonizer(
          enabled: state.model.displayNameStatus.isInProgress,
          child: AdsCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdsTitle(
                    text: intl.displayName,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    intl.displayNameDesc,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Flexible(
                        child: DisplayNameFormWidget(),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      AdsFilledButton(
                        onPressedCallback: () => bloc.add(const SaveDisplayNameEvent()),
                        text: 'Save',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
