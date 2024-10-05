import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:savepass/core/file/file_paths.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdsScreenTemplate(
      goBack: true,
      title: const AdsTitle(
        text: 'Privacy Policy',
      ),
      wrapScroll: false,
      child: SfPdfViewer.asset(
        FilePaths.privacyPolicyFile,
      ),
    );
  }
}
