import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_state.dart';
import 'package:savepass/app/password/presentation/widgets/generate_password/pass_generator_modal_widget.dart';

class PassWidget extends StatelessWidget {
  const PassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<PasswordBloc>();
    final textTheme = Theme.of(context).textTheme;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          intl.password,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: _Password()),
            BlocBuilder<PasswordBloc, PasswordState>(
              buildWhen: (previous, current) =>
                  previous.model.isUpdating != current.model.isUpdating,
              builder: (context, state) {
                final isUpdating = state.model.isUpdating;

                return Row(
                  children: [
                    SizedBox(
                      width: deviceWidth * 0.03,
                    ),
                    AdsFilledRoundIconButton(
                      icon: Icon(isUpdating ? Icons.copy : Icons.autorenew),
                      onPressedCallback: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (isUpdating) {
                          bloc.add(const CopyPassToClipboardEvent());
                        } else {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
                            builder: (BuildContext context) {
                              return SizedBox(
                                width: double.infinity,
                                height: deviceHeight * 0.70,
                                child: const PassGeneratorModalWidget(),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _Password extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  _Password();

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<PasswordBloc>();

    return BlocBuilder<PasswordBloc, PasswordState>(
      buildWhen: (previous, current) =>
          (previous.model.alreadySubmitted != current.model.alreadySubmitted) ||
          (previous.model.showPassword != current.model.showPassword) ||
          (previous.model.password != current.model.password),
      builder: (context, state) {
        final model = state.model;
        final password = model.password.value;

        if (_controller.text != password) {
          final previousSelection = _controller.selection;
          _controller.value = TextEditingValue(
            text: password,
            selection: previousSelection,
          );
        }

        return AdsTextField(
          controller: _controller,
          key: const Key('password_textField'),
          errorText: model.alreadySubmitted
              ? model.password.getError(intl, model.password.error)
              : null,
          onChanged: (value) {
            bloc.add(ChangePasswordEvent(password: value));
          },
          obscureText: !model.showPassword,
          textInputAction: TextInputAction.next,
          suffixIcon:
              model.showPassword ? Icons.visibility_off : Icons.visibility,
          onTapSuffixIcon: () => bloc.add(const TogglePasswordEvent()),
          hintText: intl.passwordHint,
        );
      },
    );
  }
}
