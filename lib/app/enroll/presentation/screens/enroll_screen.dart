import 'dart:io';

import 'package:atomic_design_system/molecules/text/ads_headline.dart';
import 'package:atomic_design_system/templates/ads_screen_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:lottie/lottie.dart';
import 'package:savepass/app/enroll/presentation/blocs/enroll_bloc.dart';
import 'package:savepass/app/enroll/presentation/blocs/enroll_event.dart';
import 'package:savepass/app/enroll/presentation/blocs/enroll_state.dart';
import 'package:savepass/app/enroll/presentation/widgets/enroll_submit_button.dart';
import 'package:savepass/app/profile/presentation/blocs/profile_bloc.dart';
import 'package:savepass/app/profile/presentation/blocs/profile_event.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/lottie/lottie_paths.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnrollScreen extends StatelessWidget {
  const EnrollScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<EnrollBloc>();
    return BlocProvider.value(
      value: bloc
        ..add(
          const EnrollInitialEvent(),
        ),
      child: const BlocListener<EnrollBloc, EnrollState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  final intl = AppLocalizations.of(context)!;

  if (state is SuccessEnrolledState) {
    SnackBarUtils.showSuccessSnackBar(context, intl.successfullyLink);
    Modular.to.pushNamedAndRemoveUntil(Routes.dashboardRoute, (_) => false);
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    final intl = AppLocalizations.of(context)!;

    return AdsScreenTemplate(
      wrapScroll: false,
      goBack: true,
      goBackCallback: () {
        final profileBloc = Modular.get<ProfileBloc>();
        profileBloc.add(const ClearValuesEvent());
      },
      child: PopScope(
        canPop: false,
        child: BlocBuilder<EnrollBloc, EnrollState>(
          buildWhen: (previous, current) =>
              (previous.model.status != current.model.status),
          builder: (context, state) {
            return Skeletonizer(
              enabled: state.model.status.isInProgress,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: deviceHeight * (Platform.isAndroid ? 0.05 : 0.02),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AdsHeadline(
                            text: intl.deviceNotRegistered,
                          ),
                          Lottie.asset(
                            width: deviceWidth * 0.4,
                            height: deviceHeight * 0.35,
                            LottiePaths.device,
                          ),
                          BlocBuilder<EnrollBloc, EnrollState>(
                            buildWhen: (previous, current) =>
                                (previous.model.enrolledDevice !=
                                    current.model.enrolledDevice),
                            builder: (context, state) {
                              final device = state.model.enrolledDevice;

                              if (device.isEmpty) {
                                return Container();
                              }

                              return RichText(
                                text: TextSpan(
                                  text: intl.currentSessionWith,
                                  style: textTheme.bodyMedium,
                                  children: [
                                    TextSpan(
                                      text: state.model.enrolledDevice,
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: deviceHeight * 0.01),
                          Text(intl.wantToLink),
                          SizedBox(height: deviceHeight * 0.025),
                          const EnrollSubmitButton(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.01),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
