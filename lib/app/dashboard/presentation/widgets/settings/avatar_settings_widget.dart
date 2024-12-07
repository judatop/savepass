import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:savepass/main.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class AvatarSettingsWidget extends StatelessWidget {
  const AvatarSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final avatarURL = user?.appMetadata['avatar_url'];

    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          previous.model.status != current.model.status,
      builder: (context, state) {
        final status = state.model.status;

        return Skeletonizer(
          enabled: status.isInProgress,
          child: AdsCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdsTitle(
                        text: 'Avatar',
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Click to change your avatar',
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
                          imageUrl: avatarURL,
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
