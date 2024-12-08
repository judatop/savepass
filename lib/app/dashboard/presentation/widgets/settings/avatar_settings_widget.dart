import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class AvatarSettingsWidget extends StatelessWidget {
  const AvatarSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          (previous.model.status != current.model.status) ||
          (previous.model.profile?.avatar != current.model.profile?.avatar),
      builder: (context, state) {
        final profile = state.model.profile;
        String? photoURL;

        if (profile != null) {
          photoURL = profile.avatar;
        }

        return Skeletonizer(
          enabled: state.model.status.isInProgress,
          child: AdsCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdsTitle(
                        text: intl.avatar,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        intl.avatarDesc,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          final bloc = Modular.get<DashboardBloc>();
                          bloc.add(const ChangeAvatarEvent());
                        },
                        child: AdsAvatar(
                          imageUrl: photoURL,
                          iconSize: 45,
                          radius: 40,
                        ),
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
