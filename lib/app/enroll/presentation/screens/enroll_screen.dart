
import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:lottie/lottie.dart';
import 'package:savepass/app/enroll/presentation/blocs/enroll_bloc.dart';
import 'package:savepass/app/enroll/presentation/blocs/enroll_event.dart';
import 'package:savepass/app/enroll/presentation/blocs/enroll_state.dart';
import 'package:savepass/app/enroll/presentation/widgets/enroll_devices_to_disable.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_bloc.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_event.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/lottie/lottie_paths.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:savepass/l10n/app_localizations.dart';

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
                          Text(intl.wantToLink),
                          SizedBox(height: deviceHeight * 0.02),
                          const EnrollDevicesToDisable(),
                          SizedBox(height: deviceHeight * 0.025),
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
