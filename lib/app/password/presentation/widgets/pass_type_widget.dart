import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:atomic_design_system/molecules/card/ads_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/password/presentation/blocs/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PassTypeWidget extends StatelessWidget {
  const PassTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<PasswordBloc>();
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Type',
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              width: 10,
            ),
            Row(
              children: [
                Text(
                  'Auto',
                  style: textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                BlocBuilder<PasswordBloc, PasswordState>(
                  buildWhen: (previous, current) =>
                      previous.model.typeAuto != current.model.typeAuto,
                  builder: (context, state) {
                    final typeAuto = state.model.typeAuto;
                    return Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: typeAuto,
                        onChanged: (value) =>
                            bloc.add(const ToggleAutoTypeEvent()),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 5),
        BlocBuilder<PasswordBloc, PasswordState>(
          buildWhen: (previous, current) =>
              previous.model.images != current.model.images,
          builder: (context, state) {
            final images = state.model.images;

            if (images.isEmpty) return Container();

            return CarouselSlider(
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 0.3,
                aspectRatio: 5.0,
                onPageChanged: (index, reason) {
                  bloc.add(OnChangeTypeEvent(newIndex: index));
                },
              ),
              items: images.map((img) {
                return Builder(
                  builder: (BuildContext context) {
                    return AdsCard(
                      borderColor: img.selected ? Colors.blue : null,
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: CachedNetworkImage(
                            imageUrl: img.value,
                            width: 65,
                            placeholder: (context, url) => Skeletonizer(
                              child: Container(
                                width: 65,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
