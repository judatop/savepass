import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/dashboard/presentation/widgets/bottom_navigation_bar.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:savepass/app/dashboard/presentation/widgets/home_widget.dart';
import 'package:savepass/app/dashboard/presentation/widgets/settings_widget.dart';
import 'package:savepass/app/dashboard/presentation/widgets/tools_widget.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<DashboardBloc>();
    return BlocProvider.value(
      value: bloc..add(const DashboardInitialEvent()),
      child: const BlocListener<DashboardBloc, DashboardState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  final intl = AppLocalizations.of(context)!;

  if (state is OpenPhotoPermissionState) {
    Modular.to.pushNamed(
      Routes.photoPermissionRoute,
      arguments: () {
        final bloc = Modular.get<DashboardBloc>();
        bloc.add(const UploadPhotoEvent());
      },
    );
  }

  if (state is GeneralErrorState) {
    SnackBarUtils.showErrroSnackBar(
      context,
      intl.genericError,
    );
  }

  if (state is LogOutState) {
    Modular.to
        .pushNamedAndRemoveUntil(Routes.getStartedRoute, (route) => false);
  }

  if (state is OpenPasswordState) {
    Modular.to.pushNamed(Routes.passwordRoute);
  }

  if (state is PasswordObtainedState) {
    SnackBarUtils.showSuccessSnackBar(
      context,
      intl.passwordCopiedClipboard,
    );
  }

  if (state is CardValueCopiedState) {
    SnackBarUtils.showSuccessSnackBar(
      context,
      intl.cardValueCopiedClipboard,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: AdsScreenTemplate(
        safeAreaBottom: false,
        safeAreaTop: true,
        wrapScroll: false,
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            BlocBuilder<DashboardBloc, DashboardState>(
              buildWhen: (previous, current) =>
                  previous.model.currentIndex != current.model.currentIndex,
              builder: (context, state) {
                final index = state.model.currentIndex;
                late final Widget content;
                switch (index) {
                  case 0:
                    content = const HomeWidget();
                    break;
                  case 1:
                    content = const ToolsWidget();
                    break;
                  case 2:
                    content = const SettingsWidget();
                    break;
                  default:
                    content = Container();
                }

                return Positioned.fill(
                  child: content,
                );
              },
            ),
            const CustomBottomNavigationBar(),
          ],
        ),
      ),
    );
  }
}
