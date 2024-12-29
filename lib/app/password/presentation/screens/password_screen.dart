import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/password/presentation/blocs/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password_state.dart';
import 'package:savepass/app/password/presentation/widgets/pass_desc_widget.dart';
import 'package:savepass/app/password/presentation/widgets/pass_domain_widget.dart';
import 'package:savepass/app/password/presentation/widgets/pass_header_widget.dart';
import 'package:savepass/app/password/presentation/widgets/pass_name_widget.dart';
import 'package:savepass/app/password/presentation/widgets/pass_user_widget.dart';
import 'package:savepass/app/password/presentation/widgets/pass_widget.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

void _listener(context, state) {
  final intl = AppLocalizations.of(context)!;

  if (state is GeneratedPasswordState) {
    SnackBarUtils.showSuccessSnackBar(context, intl.passwordGenerated);
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AdsScreenTemplate(
      goBack: false,
      safeAreaBottom: false,
      safeAreaTop: true,
      wrapScroll: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PassHeaderWidget(),
            SizedBox(height: screenHeight * 0.03),
            PassUserWidget(),
            SizedBox(height: screenHeight * 0.02),
            const PassWidget(),
            SizedBox(height: screenHeight * 0.02),
            const PassNameWidget(),
            SizedBox(height: screenHeight * 0.02),
            PassDomainWidget(),
            SizedBox(height: screenHeight * 0.02),
            PassDescWidget(),
          ],
        ),
      ),
    );
  }
}
