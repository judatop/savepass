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

class CardHolderWidget extends StatelessWidget {
  const CardHolderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final bloc = Modular.get<CardBloc>();
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cardholder Name',
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: _CardHolder()),
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
                    bloc.add(const SubmitCardHolderEvent());
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

class _CardHolder extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<CardBloc>();

    return BlocBuilder<CardBloc, CardState>(
      buildWhen: (previous, current) =>
          (previous.model.alreadySubmitted != current.model.alreadySubmitted) ||
          (previous.model.cardHolderName != current.model.cardHolderName),
      builder: (context, state) {
        final model = state.model;
        final cardHolderName = model.cardHolderName.value;
        _controller.text = cardHolderName;

        return AdsFormField(
          formField: AdsTextField(
            controller: _controller,
            key: const Key('card_name_textField'),
            keyboardType: TextInputType.text,
            errorText: model.alreadySubmitted
                ? model.cardHolderName
                    .getError(intl, model.cardHolderName.error)
                : null,
            enableSuggestions: false,
            onChanged: (value) {
              bloc.add(ChangeCardHolderEvent(cardHolderName: value));
            },
            textInputAction: TextInputAction.done,
            hintText: 'JHON DOE',
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegexUtils.lettersWithSpaceCapitalCase,
              ),
            ],
          ),
        );
      },
    );
  }
}
