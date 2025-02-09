import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:lottie/lottie.dart';
import 'package:savepass/app/search/presentation/blocs/search_bloc.dart';
import 'package:savepass/app/search/presentation/blocs/search_event.dart';
import 'package:savepass/app/search/presentation/blocs/search_state.dart';
import 'package:savepass/app/search/presentation/widgets/search_header_widget.dart';
import 'package:savepass/app/search/presentation/widgets/search_list_widget.dart';
import 'package:savepass/core/lottie/lottie_paths.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<SearchBloc>();
    return BlocProvider.value(
      value: bloc..add(const SearchInitialEvent()),
      child: const BlocListener<SearchBloc, SearchState>(
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
            const SearchHeaderWidget(),
            SizedBox(height: deviceHeight * 0.03),
            BlocBuilder<SearchBloc, SearchState>(
              buildWhen: (previous, current) =>
                  (previous.model.status != current.model.status) ||
                  (previous.model.searchItems != current.model.searchItems),
              builder: (context, state) {
                final status = state.model.status;

                if (status.isInitial) {
                  return Container();
                }

                if (state.model.searchItems.isEmpty && status.isSuccess) {
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
                          child: const SearchListWidget(),
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
