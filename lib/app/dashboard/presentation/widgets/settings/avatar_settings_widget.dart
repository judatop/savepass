import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:savepass/main.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class AvatarSettingsWidget extends StatelessWidget {
  const AvatarSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final avatarURL = user?.appMetadata['avatar_url'];

    return AdsCard(
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
                AdsAvatar(
                  imageUrl: avatarURL,
                  iconSize: 45,
                  radius: 40,
                ),
                // Positioned(
                //   bottom: 0,
                //   right: 0,
                //   child: PopupMenuButton<SampleItem>(
                //     child: AdsFilledRoundIconButton(
                //       backgroundColor: colorScheme.primary,
                //       icon: const Icon(
                //         Icons.edit,
                //         color: ADSFoundationsColors.whiteColor,
                //         size: 20,
                //       ),
                //     ),
                //     onSelected: (SampleItem item) {},
                //     itemBuilder: (BuildContext context) =>
                //         <PopupMenuEntry<SampleItem>>[
                //       PopupMenuItem<SampleItem>(
                //         value: SampleItem.itemOne,
                //         child: ListTile(
                //           leading: const Icon(Icons.visibility),
                //           title: const Text('Ver'),
                //           onTap: () => () {},
                //         ),
                //       ),
                //       PopupMenuItem<SampleItem>(
                //         value: SampleItem.itemTwo,
                //         child: ListTile(
                //           leading: const Icon(Icons.edit),
                //           title: const Text('Editar'),
                //           onTap: () => () {},
                //         ),
                //       ),
                //       PopupMenuItem<SampleItem>(
                //         value: SampleItem.itemThree,
                //         child: ListTile(
                //           leading: const Icon(Icons.close),
                //           title: const Text('Quitar'),
                //           onTap: () => () {},
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
