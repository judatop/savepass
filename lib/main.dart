import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/app_widget.dart';
import 'package:savepass/core/config/app_module.dart';
import 'package:savepass/core/env/env.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_logging/sentry_logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final webClientId = Env.googleWebClientId;
final iosClientId = Env.googleIosClientId;

final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId: iosClientId,
  serverClientId: webClientId,
  scopes: [
    'email',
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      debugPrint('[${record.level.name}] ${record.loggerName}: ${record.message}');
      if (record.error != null) debugPrint('  error: ${record.error}');
      if (record.stackTrace != null) debugPrint('  ${record.stackTrace}');
    });
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await initializeDateFormatting('es', null);

  // The Android photo picker needs no storage permission at all. Play rejects
  // READ_MEDIA_IMAGES unless the picker is technically insufficient, and the
  // plugin still defaults this to false.
  final imagePicker = ImagePickerPlatform.instance;
  if (imagePicker is ImagePickerAndroid) {
    imagePicker.useAndroidPhotoPicker = true;
  }

  await Supabase.initialize(
    url: Env.supabaseURL,
    anonKey: Env.supabaseAnonKey,
  );

  runSavePass() => runApp(
        ModularApp(
          module: AppModule(),
          child: const AppWidget(),
        ),
      );

  // The flavor without a DSN skips Sentry: initialising it anyway boots the
  // native layer and reports nothing.
  if (Env.sentryDsn.isEmpty) {
    runSavePass();
    return;
  }

  await SentryFlutter.init(
    (options) {
      options.dsn = Env.sentryDsn;
      options.sendDefaultPii = true;
      options.addIntegration(LoggingIntegration());
    },
    appRunner: runSavePass,
  );
}

final supabase = Supabase.instance.client;
