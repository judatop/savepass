import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/web.dart';

class FirebaseAuthUtils {
  static Future<void> initAuthListeners() async {
    final logger = Logger();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        logger.i('User is currently signed out!');
      } else {
        logger.i('User is signed in!');
        logger.i(
          'Welcome uid: ${user.uid}, name: ${user.displayName}, email: ${user.email}, phoneNumber: ${user.phoneNumber}, photo: ${user.photoURL} ',
        );
      }
    });
  }
}
