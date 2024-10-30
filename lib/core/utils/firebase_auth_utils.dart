import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/web.dart';
import 'package:savepass/core/config/routes.dart';

class FirebaseAuthUtils {
  static void initAuthListeners() async {
    final logger = Logger();

    // FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    //   if (user == null) {
    //     Modular.to.navigate(Routes.getStartedRoute);
    //     return;
    //   }

    //   logger.i(
    //     'User is signed in, uid: ${user.uid}, name: ${user.displayName}, email: ${user.email}',
    //   );
    // });
  }
}
