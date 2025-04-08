import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_state.dart';
import 'package:savepass/app/password/presentation/widgets/pass_action_buttons_widget.dart';
import 'package:savepass/app/password/presentation/widgets/pass_desc_widget.dart';
import 'package:savepass/app/password/presentation/widgets/pass_domain_widget.dart';
import 'package:savepass/app/password/presentation/widgets/pass_header_widget.dart';
import 'package:savepass/app/password/presentation/widgets/pass_name_widget.dart';
import 'package:savepass/app/password/presentation/widgets/pass_user_widget.dart';
import 'package:savepass/app/password/presentation/widgets/pass_widget.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PasswordScreen extends StatelessWidget {
  final String? selectedPassId;

  const PasswordScreen({
    this.selectedPassId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<PasswordBloc>();
    return BlocProvider.value(
      value: bloc..add(PasswordInitialEvent(selectedPassId: selectedPassId)),
      child: const BlocListener<PasswordBloc, PasswordState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  final intl = AppLocalizations.of(context)!;

  if (state is PasswordCreatedState) {
    final bloc = Modular.get<DashboardBloc>();
    bloc.add(const GetPasswordsEvent());
    SnackBarUtils.showSuccessSnackBar(context, intl.passwordCreated);
    Modular.to.pop();
  }

  if (state is GeneralErrorState) {
    SnackBarUtils.showErrroSnackBar(context, intl.genericError);
  }

  if (state is ErrorLoadingPasswordState) {
    SnackBarUtils.showErrroSnackBar(context, intl.genericError);
    Modular.to.pop();
  }

  if (state is PassCopiedState) {
    SnackBarUtils.showSuccessSnackBar(context, intl.passwordCopiedClipboard);
  }

  if (state is UserCopiedState) {
    SnackBarUtils.showSuccessSnackBar(context, intl.userCopiedClipboard);
  }

  if (state is PasswordDeletedState) {
    final bloc = Modular.get<DashboardBloc>();
    bloc.add(const GetPasswordsEvent());
    SnackBarUtils.showSuccessSnackBar(context, intl.passwordDeleted);
    Modular.to.pop();
  }

  if (state is ReachedPasswordsState) {
    SnackBarUtils.showErrroSnackBar(context, intl.reachedPasswordsLimit);
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return AdsScreenTemplate(
      resizeToAvoidBottomInset: false,
      goBack: false,
      safeAreaBottom: false,
      safeAreaTop: true,
      wrapScroll: false,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
                right:
                    deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
                bottom:
                    screenHeight * ADSFoundationSizes.defaultVerticalPadding,
              ),
              child: BlocBuilder<PasswordBloc, PasswordState>(
                buildWhen: (previous, current) =>
                    previous.model.status != current.model.status,
                builder: (context, state) {
                  final status = state.model.status;

                  return Skeletonizer(
                    enabled: status.isInProgress,
                    child: Column(
                      children: [
                        const PassHeaderWidget(),
                        SizedBox(height: screenHeight * 0.05),
                        const PassNameWidget(),
                        SizedBox(height: screenHeight * 0.02),
                        const PassUserWidget(),
                        SizedBox(height: screenHeight * 0.02),
                        const PassWidget(),
                        SizedBox(height: screenHeight * 0.02),
                        PassDomainWidget(),
                        SizedBox(height: screenHeight * 0.02),
                        PassDescWidget(),
                        SizedBox(height: screenHeight * 0.4),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const PassActionButtonsWidget(),
        ],
      ),
    );
  }
}
