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

void _listener(context, state) {}

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