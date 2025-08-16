import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:lottie/lottie.dart';
import 'package:savepass/app/password/presentation/blocs/password_report/password_report_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password_report/password_report_event.dart';
import 'package:savepass/app/password/presentation/blocs/password_report/password_report_state.dart';
import 'package:savepass/app/password/presentation/widgets/report/pass_report_header_widget.dart';
import 'package:savepass/app/password/presentation/widgets/report/pass_report_list_widget.dart';
import 'package:savepass/core/lottie/lottie_paths.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PasswordReportScreen extends StatelessWidget {
  const PasswordReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<PassReportBloc>();
    return BlocProvider.value(
      value: bloc..add(const PassReportInitialEvent()),
      child: const BlocListener<PassReportBloc, PassReportState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
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
        child: Column(
          children: [
            const PassReportHeaderWidget(),
            SizedBox(height: deviceHeight * 0.03),
            BlocBuilder<PassReportBloc, PassReportState>(
              buildWhen: (previous, current) =>
                  (previous.model.status != current.model.status) ||
                  (previous.model.passwords != current.model.passwords),
              builder: (context, state) {
                final status = state.model.status;

                if (status.isInitial) {
                  return Container();
                }

                if (state.model.passwords.isEmpty && status.isSuccess) {
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Lottie.asset(
                          width: deviceWidth * 0.5,
                          LottiePaths.noData,
                        ),
                        SizedBox(height: deviceHeight * 0.02),
                        AdsHeadline(text: intl.noResults),
                      ],
                    ),
                  );
                }

                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!status.isInProgress) Text(intl.tipDashboard),
                      SizedBox(
                        height: deviceHeight * 0.03,
                      ),
                      Expanded(
                        child: Skeletonizer(
                          enabled: status.isInProgress,
                          child: const PassReportListWidget(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
