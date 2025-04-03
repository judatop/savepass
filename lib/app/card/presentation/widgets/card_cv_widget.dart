import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/card/presentation/blocs/card/card_bloc.dart';
import 'package:savepass/app/card/presentation/blocs/card/card_event.dart';
import 'package:savepass/app/card/presentation/blocs/card/card_state.dart';
import 'package:savepass/core/utils/regex_utils.dart';

class CardCvvWidget extends StatelessWidget {
  const CardCvvWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final bloc = Modular.get<CardBloc>();
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final intl = AppLocalizations.of(context)!;

    return BlocBuilder<CardBloc, CardState>(
      buildWhen: (previous, current) =>
          (previous.model.status != current.model.status) ||
          (previous.model.isUpdating != current.model.isUpdating),
      builder: (context, state) {
        final isUpdating = state.model.isUpdating;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              intl.cardCvv,
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
                if (!isUpdating)
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
                          bloc.add(const SubmitCardEvent());
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

        return AdsFormField(
          formField: AdsTextFormField(
            initialValue: cvv,
            key: const Key('card_cvv_textField'),
            keyboardType: TextInputType.number,
            errorText: model.alreadySubmitted
                ? model.cardCvv.getError(intl, model.cardCvv.error)
                : null,
            enableSuggestions: false,
            onChanged: (value) {
              if (value.length == 3) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
              bloc.add(ChangeCardCvvEvent(cardCvv: value));
            },
            textInputAction: TextInputAction.done,
            hintText: '000',
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
