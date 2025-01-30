import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/card/presentation/blocs/card_bloc.dart';
import 'package:savepass/app/card/presentation/blocs/card_event.dart';
import 'package:savepass/app/card/presentation/blocs/card_state.dart';
import 'package:savepass/core/utils/regex_utils.dart';

class CardExpirationWidget extends StatelessWidget {
  const CardExpirationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final bloc = Modular.get<CardBloc>();
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final intl = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          intl.cardExpiration,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: _Month()),
            SizedBox(width: deviceWidth * 0.01),
            const AdsHeadline(text: '/'),
            SizedBox(width: deviceWidth * 0.01),
            Flexible(child: _Year()),
            Row(
              children: [
                SizedBox(
                  width: deviceWidth * 0.03,
                ),
                AdsFilledRoundIconButton(
                  backgroundColor: colorScheme.primary,
                  icon: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  onPressedCallback: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    bloc.add(const SubmitCardExpirationEvent());
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _Month extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<CardBloc>();

    return BlocBuilder<CardBloc, CardState>(
      buildWhen: (previous, current) =>
          (previous.model.alreadySubmitted != current.model.alreadySubmitted) ||
          (previous.model.expirationMonth != current.model.expirationMonth),
      builder: (context, state) {
        final model = state.model;
        final expirationMonth = model.expirationMonth.value;

        return AdsFormField(
          formField: AdsTextFormField(
            initialValue: expirationMonth,
            key: const Key('card_month_textField'),
            keyboardType: TextInputType.number,
            errorText: model.alreadySubmitted
                ? model.expirationMonth
                    .getError(intl, model.expirationMonth.error)
                : null,
            enableSuggestions: false,
            onChanged: (value) {
              bloc.add(ChangeExpirationMonth(expirationMonth: value));
            },
            textInputAction: TextInputAction.next,
            hintText: '00',
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegexUtils.numbers,
              ),
            ],
            maxLength: 2,
          ),
        );
      },
    );
  }
}

class _Year extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<CardBloc>();

    return BlocBuilder<CardBloc, CardState>(
      buildWhen: (previous, current) =>
          (previous.model.alreadySubmitted != current.model.alreadySubmitted) ||
          (previous.model.expirationYear != current.model.expirationYear),
      builder: (context, state) {
        final model = state.model;
        final expirationYear = model.expirationYear.value;

        return AdsFormField(
          formField: AdsTextFormField(
            initialValue: expirationYear,
            key: const Key('card_year_textField'),
            keyboardType: TextInputType.number,
            errorText: model.alreadySubmitted
                ? model.expirationYear
                    .getError(intl, model.expirationYear.error)
                : null,
            enableSuggestions: false,
            onChanged: (value) {
              bloc.add(ChangeExpirationYear(expirationYear: value));
            },
            textInputAction: TextInputAction.done,
            hintText: '00',
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegexUtils.numbers,
              ),
            ],
            maxLength: 2,
          ),
        );
      },
    );
  }
}
