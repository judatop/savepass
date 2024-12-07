import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:savepass/app/app_widget.dart';
import 'package:savepass/core/config/app_module.dart';
import 'package:savepass/core/env/env.dart';
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

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await initializeDateFormatting('es', null);

  await Supabase.initialize(
    url: Env.supabaseURL,
    anonKey: Env.supabaseAnonKey,
  );

  return runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}

final supabase = Supabase.instance.client;
  