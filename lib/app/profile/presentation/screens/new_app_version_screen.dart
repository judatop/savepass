import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lottie/lottie.dart';
import 'package:savepass/app/profile/presentation/blocs/new_app_version/new_app_version_bloc.dart';
import 'package:savepass/app/profile/presentation/blocs/new_app_version/new_app_version_event.dart';
import 'package:savepass/app/profile/presentation/blocs/new_app_version/new_app_version_state.dart';
import 'package:savepass/core/lottie/lottie_paths.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';

class NewAppVersionScreen extends StatelessWidget {
  const NewAppVersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<NewAppVersionBloc>();
    return BlocProvider.value(
      value: bloc,
      child: const BlocListener<NewAppVersionBloc, NewAppVersionState>(
        listener: _listener,
        child: _Body(),
      ),
    );
  }
}

void _listener(context, state) {
  final intl = AppLocalizations.of(context)!;

  if (state is GeneralErrorState) {
    SnackBarUtils.showErrroSnackBar(
      context,
      intl.genericError,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<NewAppVersionBloc>();
    final intl = AppLocalizations.of(context)!;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return AdsScreenTemplate(
      safeAreaBottom: false,
      safeAreaTop: true,
      wrapScroll: false,
      padding: EdgeInsets.zero,
      child: PopScope(
        canPop: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
            right: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
            bottom: deviceHeight * ADSFoundationSizes.defaultVerticalPadding,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: deviceHeight * 0.06),
                AdsHeadline(text: intl.newVersionAvailableTitle),
                SizedBox(height: deviceHeight * 0.05),
                Lottie.asset(
                  width: deviceWidth * 0.4,
                  LottiePaths.update,
                ),
                SizedBox(height: deviceHeight * 0.05),
                Text(
                  intl.newVersionAvailableText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: deviceHeight * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AdsFilledIconButton(
                      icon: Icons.download,
                      onPressedCallback: () =>
                          bloc.add(const DownloadNewVersionEvent()),
                      text: intl.newVersionAvailableDownload,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
