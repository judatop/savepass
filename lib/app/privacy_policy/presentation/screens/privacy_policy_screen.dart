import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:savepass/core/file/file_paths.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AdsScreenTemplate(
      goBack: true,
      title: AdsTitle(
        text: intl.privacyPolicy,
      ),
      wrapScroll: false,
      child: SfPdfViewer.asset(
        FilePaths.privacyPolicyFile,
      ),
    );
  }
}
