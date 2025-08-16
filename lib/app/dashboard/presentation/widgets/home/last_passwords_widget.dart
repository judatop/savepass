import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:savepass/app/dashboard/presentation/widgets/home/no_passwords_widget.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/image/image_paths.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:savepass/l10n/app_localizations.dart';

class LastPasswordsWidget extends StatelessWidget {
  const LastPasswordsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<DashboardBloc>();
    final colorScheme = Theme.of(context).colorScheme;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          (previous.model.passwords != current.model.passwords) ||
          (previous.model.passwordStatus != current.model.passwordStatus),
      builder: (context, state) {
        final status = state.model.passwordStatus;

        return Skeletonizer(
          enabled: status.isInProgress,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AdsFilledRoundIconButton(
                    backgroundColor: colorScheme.primary,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressedCallback: () =>
                        bloc.add(const OnClickNewPassword()),
                    tooltip: intl.toolTipAddPassword,
                  ),
                  SizedBox(width: deviceWidth * 0.04),
                  AdsTitle(
                    text: intl.passwordsTitleDashboard,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(
                height: deviceHeight * 0.02,
              ),
              BlocBuilder<DashboardBloc, DashboardState>(
                buildWhen: (previous, current) =>
                    previous.model.passwords != current.model.passwords,
                builder: (context, state) {
                  final list = state.model.passwords;

                  if (list.isEmpty) {
                    return const NoPasswordsWidget();
                  }

                  return CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.7,
                      aspectRatio: 3.5,
                      enableInfiniteScroll: false,
                    ),
                    items: list.map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return AdsCard(
                            onLongPress: () {
                              bloc.add(
                                CopyPasswordEvent(
                                  password: item,
                                ),
                              );
                            },
                            onTap: () {
                              Modular.to.pushNamed(
                                Routes.passwordRoute,
                                arguments: item.id,
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: deviceWidth * 0.05,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: deviceWidth * 0.45,
                                        child: AdsSubtitle(
                                          textAlign: TextAlign.left,
                                          text: item.name?.isNotEmpty ?? false
                                              ? item.name!
                                              : intl.password,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        height: deviceHeight * 0.001,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.person,
                                            size: 13,
                                          ),
                                          const SizedBox(width: 5),
                                          SizedBox(
                                            width: deviceWidth * 0.35,
                                            child: Text(
                                              item.password.split('|')[0],
                                              style: const TextStyle(
                                                fontSize: 14.5,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  item.typeImg != null
                                      ? Image.network(
                                          item.typeImg!,
                                          width: deviceWidth * 0.06,
                                        )
                                      : Image.asset(ImagePaths.passwordImage),
                                ],
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
          ),
        );
      },
    );
  }
}
