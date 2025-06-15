import 'dart:io';

import 'package:atomic_design_system/molecules/button/ads_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_state.dart';
import 'package:savepass/app/password/presentation/widgets/generate_password/pass_generator_numbers_switch_widget.dart';
import 'package:savepass/app/password/presentation/widgets/generate_password/pass_generator_slider_widget.dart';
import 'package:savepass/app/password/presentation/widgets/generate_password/pass_generator_switch_widget.dart';
import 'package:savepass/app/password/presentation/widgets/generate_password/pass_generator_symbols_switch_widget.dart';
import 'package:savepass/app/password/presentation/widgets/generate_password/pass_generator_text_widget.dart';
import 'package:savepass/app/password/presentation/widgets/generate_password/pass_generator_upper_lower_switch_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PassGeneratorModalWidget extends StatelessWidget {
  const PassGeneratorModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<PasswordBloc>();
    return BlocProvider.value(
      value: bloc,
      child: const BlocListener<PasswordBloc, PasswordState>(
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
    final bloc = Modular.get<PasswordBloc>();
    final intl = AppLocalizations.of(context)!;

    return SafeArea(
      bottom: true,
      child: Stack(
        children: [
          Positioned(
            top: deviceHeight * 0.01,
            right: deviceWidth * 0.06,
            child: Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => Modular.to.pop(),
                child: Text(
                  intl.close,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: deviceWidth * 0.06,
              vertical: deviceHeight * 0.08,
            ),
            child: SingleChildScrollView(
              child: Skeletonizer(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PassGeneratorTextWidget(),
                    SizedBox(
                      height: deviceHeight * 0.03,
                    ),
                    const PassGeneratorSliderWidget(),
                    SizedBox(
                      height: deviceHeight * 0.01,
                    ),
                    const PassGeneratorSwitchWidget(),
                    SizedBox(
                      height: deviceHeight * 0.01,
                    ),
                    const PassGeneratorUpperLowerSwitchWidget(),
                    SizedBox(
                      height: deviceHeight * 0.01,
                    ),
                    const PassGeneratorNumbersSwitchWidget(),
                    SizedBox(
                      height: deviceHeight * 0.01,
                    ),
                    const PassGeneratorSymbolsSwitchWidget(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: Platform.isAndroid ? deviceHeight * 0.015 : 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.06),
              child: AdsFilledButton(
                onPressedCallback: () {},
                text: intl.saveText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
