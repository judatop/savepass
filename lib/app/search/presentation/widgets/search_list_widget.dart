import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/card/presentation/widgets/copy_card_value_bottom_sheet_widget.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/search/infrastructure/models/search_type_enum.dart';
import 'package:savepass/app/search/presentation/blocs/search_bloc.dart';
import 'package:savepass/app/search/presentation/blocs/search_event.dart';
import 'package:savepass/app/search/presentation/blocs/search_state.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchListWidget extends StatelessWidget {
  const SearchListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final bloc = Modular.get<SearchBloc>();

    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (previous, current) =>
          previous.model.searchItems != current.model.searchItems,
      builder: (context, state) {
        final items = state.model.searchItems;

        return ListView.separated(
          itemCount: items.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final item = items[index];

            return ListTile(
              onLongPress: () {
                final bloc = Modular.get<DashboardBloc>();
                if (item.type == SearchType.password.name) {
                  bloc.add(
                    CopyPasswordEvent(
                      passwordUuid: item.vaultId,
                    ),
                  );
                } else {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: deviceHeight * 0.70,
                        child: CopyCardValueBottomSheetWidget(
                          status: FormzSubmissionStatus.initial,
                          vaultId: item.vaultId,
                        ),
                      );
                    },
                  );
                }
              },
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                if (item.type == SearchType.password.name) {
                  await Modular.to.pushNamed(
                    Routes.passwordRoute,
                    arguments: item.id,
                  );
                  debugPrint('regreso!');
                } else {
                  await Modular.to.pushNamed(
                    Routes.cardRoute,
                    arguments: item.id,
                  );
                }
                bloc.add(const SubmitSearchEvent());
              },
              title: AdsSubtitle(
                text: item.title,
                textAlign: TextAlign.start,
              ),
              subtitle: Text(
                item.subtitle,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontWeight: FontWeight.w200,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              leading: item.imgUrl != null
                  ? CachedNetworkImage(
                      imageUrl: item.imgUrl!,
                      width: deviceWidth * 0.12,
                      placeholder: (context, url) => Skeletonizer(
                        child: Container(
                          width: 20,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : const Icon(Icons.security),
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
