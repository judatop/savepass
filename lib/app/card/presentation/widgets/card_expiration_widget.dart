import 'package:atomic_design_system/molecules/button/ads_filled_round_icon_button.dart';
import 'package:atomic_design_system/molecules/text/ads_text_field.dart';
import 'package:atomic_design_system/organisms/ads_form_field.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expiration Date',
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
            SizedBox(width: deviceWidth * 0.02),
            Flexible(child: _Year()),
            Row(
              children: [
                SizedBox(
                  width: deviceWidth * 0.03,
                ),
                AdsFilledRoundIconButton(
                  icon: const Icon(Icons.check),
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
  final TextEditingController _controller = TextEditingController();

  _Month();

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
        _controller.text = expirationMonth;

        return AdsFormField(
          formField: AdsTextField(
            controller: _controller,
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
  final TextEditingController _controller = TextEditingController();

  _Year();

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
        _controller.text = expirationYear;

        return AdsFormField(
          formField: AdsTextField(
            controller: _controller,
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
