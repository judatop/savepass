import 'package:atomic_design_system/molecules/text/ads_subtitle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/card/presentation/blocs/card_report/card_report_bloc.dart';
import 'package:savepass/app/card/presentation/blocs/card_report/card_report_event.dart';
import 'package:savepass/app/card/presentation/blocs/card_report/card_report_state.dart';
import 'package:savepass/app/card/presentation/widgets/copy_card_value_bottom_sheet_widget.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/image/image_paths.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardReportListWidget extends StatelessWidget {
  const CardReportListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final bloc = Modular.get<CardReportBloc>();

    return BlocBuilder<CardReportBloc, CardReportState>(
      buildWhen: (previous, current) =>
          previous.model.cards != current.model.cards,
      builder: (context, state) {
        final items = state.model.cards;

        return ListView.separated(
          itemCount: items.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final item = items[index];

            return ListTile(
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: deviceHeight * 0.70,
                      child: CopyCardValueBottomSheetWidget(
                        status: FormzSubmissionStatus.initial,
                        card: item,
                      ),
                    );
                  },
                );
              },
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                await Modular.to.pushNamed(
                  Routes.cardRoute,
                  arguments: item.id,
                );
                bloc.add(const CardReportInitialEvent());
              },
              title: AdsSubtitle(
                text: item.card.split('|').first,
                textAlign: TextAlign.start,
              ),
              subtitle: Text(
                item.card.split('|')[1],
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontWeight: FontWeight.w200,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              leading: item.imgUrl != null
                  ? CachedNetworkImage(
                      imageUrl: item.imgUrl!,
                      width: deviceWidth * 0.11,
                      placeholder: (context, url) => Skeletonizer(
                        child: Container(
                          width: 20,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : Image.asset(
                      ImagePaths.chipImage,
                      width: deviceWidth * 0.11,
                    ),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: deviceHeight * 0.015,
            );
          },
        );
      },
    );
  }
}
