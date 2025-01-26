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

class CardCvvWidget extends StatelessWidget {
  const CardCvvWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final bloc = Modular.get<CardBloc>();
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<CardBloc, CardState>(
      buildWhen: (previous, current) =>
          previous.model.status != current.model.status,
      builder: (context, state) {
        debugPrint('status: ${state.model.status}');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Card Security Code (CVV)',
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: _Cvv()),
                Row(
                  children: [
                    SizedBox(
                      width: deviceWidth * 0.03,
                    ),
                    AdsFilledRoundIconButton(
                      icon: const Icon(Icons.check),
                      onPressedCallback: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        bloc.add(const SubmitCvvEvent());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _Cvv extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  _Cvv();

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<CardBloc>();

    return BlocBuilder<CardBloc, CardState>(
      buildWhen: (previous, current) =>
          (previous.model.alreadySubmitted != current.model.alreadySubmitted) ||
          (previous.model.cardCvv != current.model.cardCvv),
      builder: (context, state) {
        final model = state.model;
        final cvv = model.cardCvv.value;
        _controller.text = cvv;

        return AdsFormField(
          formField: AdsTextField(
            controller: _controller,
            key: const Key('card_cvv_textField'),
            keyboardType: TextInputType.number,
            errorText: model.alreadySubmitted
                ? model.cardCvv.getError(intl, model.cardCvv.error)
                : null,
            enableSuggestions: false,
            onChanged: (value) {
              bloc.add(ChangeCardCvvEvent(cardCvv: value));
            },
            textInputAction: TextInputAction.done,
            hintText: 'XXX',
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegexUtils.numbers,
              ),
            ],
            maxLength: 3,
          ),
        );
      },
    );
  }
}
