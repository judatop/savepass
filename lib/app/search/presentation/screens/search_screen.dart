import 'package:atomic_design_system/foundations/ads_foundation_sizes.dart';
import 'package:atomic_design_system/molecules/text/ads_headline.dart';
import 'package:atomic_design_system/templates/ads_screen_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/search/presentation/blocs/search_bloc.dart';
import 'package:savepass/app/search/presentation/blocs/search_event.dart';
import 'package:savepass/app/search/presentation/blocs/search_state.dart';
import 'package:savepass/app/search/presentation/widgets/search_header_widget.dart';
import 'package:savepass/app/search/presentation/widgets/search_list_widget.dart';
import 'package:savepass/app/search/presentation/widgets/search_widget.dart';

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
            SizedBox(height: deviceHeight * 0.02),
            const Expanded(child: SearchListWidget()),
          ],
        ),
      ),
    );
  }
}
