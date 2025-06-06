import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static final String supabaseURL = _Env.supabaseURL;

  @EnviedField(varName: 'SUPABASE_ANON_KEY', obfuscate: true)
  static final String supabaseAnonKey = _Env.supabaseAnonKey;

  @EnviedField(varName: 'SUPABASE_BUCKET', obfuscate: true)
  static final String supabaseBucket = _Env.supabaseBucket;

  @EnviedField(varName: 'SUPABASE_BUCKET_AVATARS_FOLDER', obfuscate: true)
  static final String supabaseBucketAvatarsFolder =
      _Env.supabaseBucketAvatarsFolder;

  @EnviedField(varName: 'GOOGLE_WEB_CLIENT_ID', obfuscate: true)
  static final String googleWebClientId = _Env.googleWebClientId;

  @EnviedField(varName: 'GOOGLE_IOS_CLIENT_ID', obfuscate: true)
  static final String googleIosClientId = _Env.googleIosClientId;

  @EnviedField(varName: 'SUPABASE_REDIRECT_URL', obfuscate: true)
  static final String supabaseRedirectUrl = _Env.supabaseRedirectUrl;

  @EnviedField(varName: 'BIOMETRIC_HASH_KEY', obfuscate: true)
  static final String biometricHashKey = _Env.biometricHashKey;

  @EnviedField(varName: 'DERIVED_KEY', obfuscate: true)
  static final String derivedKey = _Env.derivedKey;

  @EnviedField(varName: 'SENTRY_DSN', obfuscate: true)
  static final String sentryDsn = _Env.sentryDsn;
}
