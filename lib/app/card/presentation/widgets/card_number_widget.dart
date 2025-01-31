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
            const Flexible(child: _Card()),
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
  const _Card();

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

        return AdsFormField(
          formField: AdsTextFormField(
            initialValue: cardNumber,
            hintText: '0000000000000000',
            errorText: model.alreadySubmitted
                ? model.cardNumber.getError(intl, model.cardNumber.error)
                : null,
            counterText: '',
            key: const Key('card_number_textField'),
            keyboardType: TextInputType.number,
            enableSuggestions: false,
            onChanged: (value) {
              bloc.add(ChangeCardNumberEvent(cardNumber: value));
            },
            textInputAction: TextInputAction.done,
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
