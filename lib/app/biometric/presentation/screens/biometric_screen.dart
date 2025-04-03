import 'package:atomic_design_system/foundations/ads_foundation_sizes.dart';
import 'package:atomic_design_system/molecules/text/ads_headline.dart';
import 'package:atomic_design_system/templates/ads_screen_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:lottie/lottie.dart';
import 'package:savepass/app/biometric/presentation/blocs/biometric_bloc.dart';
import 'package:savepass/app/biometric/presentation/blocs/biometric_event.dart';
import 'package:savepass/app/biometric/presentation/blocs/biometric_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/app/biometric/presentation/widgets/biometric_header_widget.dart';
import 'package:savepass/app/biometric/presentation/widgets/biometric_master_password_widget.dart';
import 'package:savepass/app/biometric/presentation/widgets/submit_biometric_widget.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/core/lottie/lottie_paths.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BiometricScreen extends StatelessWidget {
  const BiometricScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<BiometricBloc>();
    return BlocProvider.value(
      value: bloc
        ..add(
          const BiometricInitialEvent(),
        ),
      child: const BlocListener<BiometricBloc, BiometricState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  final intl = AppLocalizations.of(context)!;

  if (state is InvalidMasterPasswordState) {
    SnackBarUtils.showErrroSnackBar(context, intl.invalidCredentials);
  }

  if (state is GeneralErrorState) {
    SnackBarUtils.showErrroSnackBar(context, intl.genericError);
  }

  if (state is EnrolledSuccessfulState) {
    SnackBarUtils.showSuccessSnackBar(context, intl.biometricsEnrolled);
    final bloc = Modular.get<DashboardBloc>();
    bloc.add(const CheckBiometricsEvent());
    Modular.to.pop();
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;
    final intl = AppLocalizations.of(context)!;

    return AdsScreenTemplate(
      safeAreaBottom: false,
      safeAreaTop: true,
      wrapScroll: false,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.only(
          left: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
          right: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
          bottom: deviceHeight * ADSFoundationSizes.defaultVerticalPadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const BiometricHeaderWidget(),
              BlocBuilder<BiometricBloc, BiometricState>(
                buildWhen: (previous, current) =>
                    (previous.model.status != current.model.status),
                builder: (context, state) {
                  return Skeletonizer(
                    enabled: state.model.status.isInProgress,
                    child: Column(
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            colorScheme.primary,
                            BlendMode.modulate,
                          ),
                          child: Lottie.asset(
                            LottiePaths.biometrics,
                            width: deviceWidth * 0.5,
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.015),
                        AdsHeadline(text: intl.enableBiometricsTitle),
                        SizedBox(height: deviceHeight * 0.05),
                        Text(intl.enableBiometricsText),
                        SizedBox(height: deviceHeight * 0.025),
                        const BiometricMasterPasswordWidget(),
                        SizedBox(height: deviceHeight * 0.05),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SubmitBiometricWidget(),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: deviceHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
