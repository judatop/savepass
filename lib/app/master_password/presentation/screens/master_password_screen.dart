import 'package:atomic_design_system/foundations/ads_foundation_sizes.dart';
import 'package:atomic_design_system/molecules/text/ads_headline.dart';
import 'package:atomic_design_system/templates/ads_screen_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/master_password/presentation/blocs/master_password_bloc.dart';
import 'package:savepass/app/master_password/presentation/blocs/master_password_event.dart';
import 'package:savepass/app/master_password/presentation/blocs/master_password_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/app/master_password/presentation/widget/master_password_header_widget.dart';
import 'package:savepass/app/master_password/presentation/widget/new_password_widget.dart';
import 'package:savepass/app/master_password/presentation/widget/old_password_widget.dart';
import 'package:savepass/app/master_password/presentation/widget/repeat_password_widget.dart';
import 'package:savepass/app/master_password/presentation/widget/submit_update_master_password_widget.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MasterPasswordScreen extends StatelessWidget {
  const MasterPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<MasterPasswordBloc>();
    return BlocProvider.value(
      value: bloc..add(const MasterPasswordInitialEvent()),
      child: const BlocListener<MasterPasswordBloc, MasterPasswordState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  final intl = AppLocalizations.of(context)!;

  if (state is PasswordsMismatchState) {
    SnackBarUtils.showErrroSnackBar(context, intl.passwordMissmatch);
  }

  if (state is GeneralErrorState) {
    SnackBarUtils.showErrroSnackBar(context, intl.genericError);
  }

  if (state is InvalidMasterPasswordState) {
    SnackBarUtils.showErrroSnackBar(context, intl.invalidCredentials);
  }

  if (state is MasterPasswordUpdatedState) {
    SnackBarUtils.showSuccessSnackBar(context, intl.masterPasswordUpdated);
    final dashboardBloc = Modular.get<DashboardBloc>();
    dashboardBloc.add(const GetPasswordsEvent());
    dashboardBloc.add(const GetCardsEvent());
    Modular.to.pop();
  }

  if (state is SamePasswordsMasterPasswordState) {
    SnackBarUtils.showErrroSnackBar(context, intl.newPasswordBeDiferent);
  }
  
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final intl = AppLocalizations.of(context)!;

    return AdsScreenTemplate(
      safeAreaBottom: false,
      safeAreaTop: true,
      wrapScroll: false,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.only(
          left: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
          right: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
          bottom: deviceHeight * ADSFoundationSizes.defaultVerticalPadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const MasterPasswordHeaderWidget(),
              BlocBuilder<MasterPasswordBloc, MasterPasswordState>(
                buildWhen: (previous, current) =>
                    (previous.model.status != current.model.status),
                builder: (context, state) {
                  return Skeletonizer(
                    enabled: state.model.status.isInProgress,
                    child: Column(
                      children: [
                        SizedBox(height: deviceHeight * 0.05),
                        AdsHeadline(text: intl.updateMasterPasswordTitle),
                        SizedBox(height: deviceHeight * 0.05),
                        const OldPasswordWidget(),
                        SizedBox(height: deviceHeight * 0.025),
                        const NewPasswordWidget(),
                        SizedBox(height: deviceHeight * 0.025),
                        const RepeatPasswordWidget(),
                        SizedBox(height: deviceHeight * 0.025),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SubmitUpdateMasterPasswordWidget(),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: deviceHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
