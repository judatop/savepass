import 'dart:io';

import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/password/presentation/blocs/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password_state.dart';
import 'package:savepass/app/password/presentation/widgets/pass_action_buttons_widget.dart';
import 'package:savepass/app/password/presentation/widgets/pass_desc_widget.dart';
import 'package:savepass/app/password/presentation/widgets/pass_domain_widget.dart';
import 'package:savepass/app/password/presentation/widgets/pass_name_widget.dart';
import 'package:savepass/app/password/presentation/widgets/pass_type_widget.dart';
import 'package:savepass/app/password/presentation/widgets/pass_user_widget.dart';
import 'package:savepass/app/password/presentation/widgets/pass_widget.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<PasswordBloc>();
    return BlocProvider.value(
      value: bloc..add(const PasswordInitialEvent()),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AdsScreenTemplate(
      goBack: false,
      safeAreaBottom: false,
      safeAreaTop: true,
      padding: EdgeInsets.zero,
      wrapScroll: false,
      paddingAppBar: EdgeInsets.only(
        top: (ADSFoundationSizes.defaultVerticalPadding / 2) * screenHeight,
        left: screenWidth * ADSFoundationSizes.defaultHorizontalPadding,
        right: screenWidth * ADSFoundationSizes.defaultHorizontalPadding,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: screenHeight * (Platform.isAndroid ? 0.01 : 0.05),
                right:
                    screenWidth * ADSFoundationSizes.defaultHorizontalPadding,
                left: screenWidth * ADSFoundationSizes.defaultHorizontalPadding,
              ),
              child: Container(
                color: Colors.transparent,
                height: screenHeight * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AdsFilledRoundIconButton(
                            icon: const Icon(
                              Icons.keyboard_arrow_left,
                            ),
                            onPressedCallback: () {
                              Modular.to.pop();
                            },
                          ),
                          SizedBox(
                            width: screenWidth * 0.05,
                          ),
                          const AdsHeadline(text: 'Password'),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      const PassTypeWidget(),
                      SizedBox(height: screenHeight * 0.02),
                      PassNameWidget(),
                      SizedBox(height: screenHeight * 0.02),
                      PassUserWidget(),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(child: PassWidget()),
                          const SizedBox(
                            width: 10,
                          ),
                          AdsFilledRoundIconButton(
                            onPressedCallback: () {},
                            icon: const Icon(Icons.sync),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      PassDescWidget(),
                      SizedBox(height: screenHeight * 0.02),
                      PassDomainWidget(),
                      SizedBox(height: screenHeight * 0.02),
                      SizedBox(height: screenHeight * 0.15),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const PassActionButtonsWidget(),
        ],
      ),
    );
  }
}
