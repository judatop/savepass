import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/sync_pass/presentation/blocs/sync_bloc.dart';
import 'package:savepass/app/sync_pass/presentation/blocs/sync_event.dart';
import 'package:savepass/app/sync_pass/presentation/blocs/sync_state.dart';
import 'package:savepass/app/sync_pass/presentation/widgets/master_password_widget.dart';
import 'package:savepass/app/sync_pass/presentation/widgets/submit_sync_pass_widget.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SyncPassScreen extends StatelessWidget {
  const SyncPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<SyncBloc>();
    return BlocProvider.value(
      value: bloc..add(const SyncInitialEvent()),
      child: const BlocListener<SyncBloc, SyncState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  final intl = AppLocalizations.of(context)!;

  if (state is OpenHomeState) {
    Modular.to.pushNamedAndRemoveUntil(Routes.dashboardRoute, (route) => false);
  }

  if (state is GeneralErrorState) {
    SnackBarUtils.showErrroSnackBar(context, intl.genericError);
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final intl = AppLocalizations.of(context)!;

    return AdsScreenTemplate(
      wrapScroll: true,
      child: PopScope(
        canPop: false,
        child: BlocBuilder<SyncBloc, SyncState>(
          buildWhen: (previous, current) =>
              (previous.model.status != current.model.status),
          builder: (context, state) {
            return Skeletonizer(
              enabled: state.model.status.isInProgress,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: deviceHeight * 0.15),
                  AdsHeadline(text: intl.registerMasterPassword),
                  SizedBox(height: deviceHeight * 0.05),
                  Text(
                    intl.masterPasswordText,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: deviceHeight * 0.025),
                  const MasterPasswordWidget(),
                  SizedBox(height: deviceHeight * 0.025),
                  const SubmitSyncPassWidget(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
