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

class CardNumberWidget extends StatelessWidget {
  const CardNumberWidget({super.key});

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
          intl.cardNumber,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: _Card()),
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
                    bloc.add(const SubmitCardNumberEvent());
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

class _Card extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  _Card();

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<CardBloc>();

    return BlocBuilder<CardBloc, CardState>(
      buildWhen: (previous, current) =>
          (previous.model.alreadySubmitted != current.model.alreadySubmitted) ||
          (previous.model.cardNumber != current.model.cardNumber),
      builder: (context, state) {
        final model = state.model;
        final cardNumber = model.cardNumber.value;
        _controller.text = cardNumber;

        return AdsFormField(
          formField: AdsTextField(
            controller: _controller,
            key: const Key('card_number_textField'),
            keyboardType: TextInputType.number,
            errorText: model.alreadySubmitted
                ? model.cardNumber.getError(intl, model.cardNumber.error)
                : null,
            enableSuggestions: false,
            onChanged: (value) {
              bloc.add(ChangeCardNumberEvent(cardNumber: value));
            },
            textInputAction: TextInputAction.done,
            hintText: '0000000000000000',
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegexUtils.numbers,
              ),
            ],
            maxLength: 16,
          ),
        );
      },
    );
  }
}
