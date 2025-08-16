import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lottie/lottie.dart';
import 'package:savepass/app/profile/presentation/blocs/experiencing_issues/experiencing_issues_bloc.dart';
import 'package:savepass/app/profile/presentation/blocs/experiencing_issues/experiencing_issues_event.dart';
import 'package:savepass/app/profile/presentation/blocs/experiencing_issues/experiencing_issues_state.dart';
import 'package:savepass/core/lottie/lottie_paths.dart';

class WeAreExperiencingIssuesScreen extends StatelessWidget {
  const WeAreExperiencingIssuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<ExperiencingIssuesBloc>();
    return BlocProvider.value(
      value: bloc..add(const ExperiencingIssuesInitialEvent()),
      child:
          const BlocListener<ExperiencingIssuesBloc, ExperiencingIssuesState>(
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
    final intl = AppLocalizations.of(context)!;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return AdsScreenTemplate(
      safeAreaBottom: false,
      safeAreaTop: true,
      wrapScroll: false,
      padding: EdgeInsets.zero,
      child: PopScope(
        canPop: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
            right: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
            bottom: deviceHeight * ADSFoundationSizes.defaultVerticalPadding,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: deviceHeight * 0.06),
                AdsHeadline(text: intl.weApologize),
                SizedBox(height: deviceHeight * 0.03),
                Lottie.asset(
                  width: deviceWidth * 0.5,
                  LottiePaths.error,
                ),
                Text(
                  intl.weAreExpectingSomeIssues,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
