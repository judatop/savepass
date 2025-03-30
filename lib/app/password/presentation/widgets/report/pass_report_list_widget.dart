import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/password/presentation/blocs/password_report/password_report_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password_report/password_report_event.dart';
import 'package:savepass/app/password/presentation/blocs/password_report/password_report_state.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PassReportListWidget extends StatelessWidget {
  const PassReportListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final bloc = Modular.get<PassReportBloc>();

    return BlocBuilder<PassReportBloc, PassReportState>(
      buildWhen: (previous, current) =>
          previous.model.passwords != current.model.passwords,
      builder: (context, state) {
        final items = state.model.passwords;

        return ListView.separated(
          itemCount: items.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final item = items[index];

            return ListTile(
              onLongPress: () {
                final bloc = Modular.get<DashboardBloc>();
                bloc.add(
                  CopyPasswordEvent(
                    password: item,
                  ),
                );
              },
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                await Modular.to.pushNamed(
                  Routes.passwordRoute,
                  arguments: item.id,
                );
                bloc.add(const PassReportInitialEvent());
              },
              title: AdsSubtitle(
                text: item.name ?? 'Password',
                textAlign: TextAlign.start,
              ),
              subtitle: Text(
                item.username,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontWeight: FontWeight.w200,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              leading: item.typeImg != null
                  ? CachedNetworkImage(
                      imageUrl: item.typeImg!,
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
