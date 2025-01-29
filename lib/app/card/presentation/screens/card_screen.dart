import 'package:animate_do/animate_do.dart';
import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/card/presentation/blocs/card_bloc.dart';
import 'package:savepass/app/card/presentation/blocs/card_event.dart';
import 'package:savepass/app/card/presentation/blocs/card_state.dart';
import 'package:savepass/app/card/presentation/widgets/card_cv_widget.dart';
import 'package:savepass/app/card/presentation/widgets/card_expiration_widget.dart';
import 'package:savepass/app/card/presentation/widgets/card_header_widget.dart';
import 'package:savepass/app/card/presentation/widgets/card_holder_widget.dart';
import 'package:savepass/app/card/presentation/widgets/card_number_widget.dart';
import 'package:savepass/app/card/presentation/widgets/card_widget.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardScreen extends StatelessWidget {
  final String? cardId;

  const CardScreen({
    this.cardId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<CardBloc>();
    return BlocProvider.value(
      value: bloc..add(CardInitialEvent(cardId: cardId)),
      child: const BlocListener<CardBloc, CardState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  final intl = AppLocalizations.of(context)!;

  if (state is MinLengthErrorCardState) {
    SnackBarUtils.showErrroSnackBar(
      context,
      intl.cardMinLength,
    );
  }

  if(state is CardCreatedState){
    final bloc = Modular.get<DashboardBloc>();
    bloc.add(const DashboardInitialEvent());
    SnackBarUtils.showSuccessSnackBar(context, intl.cardCreated);
    Modular.to.pop();
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return AdsScreenTemplate(
      resizeToAvoidBottomInset: false,
      goBack: false,
      safeAreaBottom: false,
      safeAreaTop: true,
      wrapScroll: false,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
                right:
                    deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
                bottom:
                    deviceHeight * ADSFoundationSizes.defaultVerticalPadding,
              ),
              child: Column(
                children: [
                  const CardHeaderWidget(),
                  SizedBox(height: deviceHeight * 0.05),
                  FlipInY(
                    duration: const Duration(seconds: 1),
                    child: const CardWidget(),
                  ),
                  SizedBox(height: deviceHeight * 0.05),
                  BlocBuilder<CardBloc, CardState>(
                    buildWhen: (previous, current) =>
                        previous.model.step != current.model.step,
                    builder: (context, state) {
                      final step = state.model.step;

                      return Column(
                        children: [
                          if (step == 1) const CardNumberWidget(),
                          if (step == 2) const CardHolderWidget(),
                          if (step == 3) const CardExpirationWidget(),
                          if (step == 4) const CardCvvWidget(),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: deviceHeight * 0.9),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
