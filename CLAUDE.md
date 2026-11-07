# savepass

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SavePass is a Flutter password/card manager (iOS + Android). Supabase is the backend (auth, Postgres RPCs, storage). All secrets live in `.env` files and are compiled into the binary via `envied` obfuscation.

## Commands

Environment setup is mandatory before running: `build.sh <dev|prod>` copies `.env.<flavor>` to `.env` and regenerates `lib/core/env/env.g.dart`. Nothing compiles without that generated file.

```bash
./build.sh dev                 # switch env + regenerate env.g.dart (do this after ANY .env change)
flutter pub get
flutter run --flavor dev -t lib/main.dart --dart-define=ENABLE_SENTRY=false
flutter run --flavor prod --release -t lib/main.dart --dart-define=ENABLE_SENTRY=true
flutter analyze                # lint (flutter_lints + prefer_single_quotes + require_trailing_commas)
dart run build_runner build --delete-conflicting-outputs   # envied codegen only
flutter gen-l10n               # regenerate lib/l10n/app_localizations*.dart from the .arb files
```

`--flavor` is required on every run/build: flavors are `dev` and `prod` (Android product flavors with distinct applicationIds `com.juda.savepassdev` / `com.juda.savepass`; iOS schemes `dev` / `prod`). The VS Code launch configs in `.vscode/launch.json` wire the `build.sh` pre-launch task automatically. (`ENABLE_SENTRY` is passed by those configs but is not read anywhere in Dart — Sentry is initialized unconditionally in `main.dart`.)

There is no `test/` directory and no test dependencies beyond `flutter_test`; there is currently no test suite to run.

## Architecture

Following clean architecture:

### Entry & Auth Flow
New user can sign in using Google/Github/Username and Password -> Then, they need to set a master password, which is the key for encrypting and decrypting their data. After that, they can access the dashboard and manage their passwords and cards. The app also supports biometric authentication for convenience. If they forget their master password, they can not recover their data this is a 0 knowledge architecture, so they need to reset their account and start over. The app also supports syncing data across devices using Supabase as the backend.

### Layering

`lib/app/<feature>/` holds one folder per feature (`auth`, `auth_init`, `biometric`, `card`, `dashboard`, `enroll`, `get_started`, `master_password`, `password`, `preferences`, `profile`, `search`, `splash`, `sync_pass`), each split into:

- `domain/` — abstract `Datasource` and `Repository` interfaces (plus occasional entities).
- `infrastructure/` — `models/` (JSON), `datasources/` (`Supabase<Feature>Datasource`), `repositories_impl/` (thin pass-through to the datasource). Note the inconsistent folder naming across features: `repositories/` vs `repositories_impl/`, and `profile/infraestructure/` is misspelled — follow whatever the feature already uses.
- `presentation/` — `blocs/`, `screens/`, `widgets/`.

Everything returns `Either<Fail, SavePassResponseModel>` (dartz). Datasources catch all exceptions, `log.severe(...)`, and return `Left(Fail(SnackBarErrors.generalErrorCode))`; blocs branch on `fold`.

### DI and routing

`lib/core/config/app_module.dart` is the single flutter_modular `Module`: every repository, datasource, util and bloc is registered as `addSingleton`, and every screen route is declared there. Adding a feature means editing this one file plus `lib/core/config/routes.dart` (route name constants). Dependencies are resolved by constructor named parameters — `Modular.get<T>()` is used for cross-bloc access (notably `ProfileBloc`).

Blocs are **app-wide singletons**, so their state persists across navigation. Blocs must re-initialize themselves via an `<Feature>InitialEvent` on screen entry rather than assuming a fresh state.

### Bloc convention

Each bloc folder has `*_bloc.dart`, `*_event.dart`, `*_state.dart`. States are `abstract class XState extends Equatable` carrying a single immutable `XStateModel model`; state *classes* signal what happened (`ChangeXState`, `LoadingXState`, `GeneralErrorState`, ...) while the model carries all data. Mutations emit `ChangeXState(state.model.copyWith(...))`. Form fields use `formz` inputs from `lib/core/form/` (`EmailForm`, `PasswordForm`, `TextForm`).

### API access

All backend calls go through `SupabaseMiddleware.doHttp(rpc:, params:)` (`lib/core/api/supabase_middleware.dart`) — the app calls **Postgres RPC functions only**, never table queries. RPC and table name constants live in `lib/core/utils/db_utils.dart`; response codes in `lib/core/api/api_codes.dart`.

The middleware injects the current JWT (read from `ProfileBloc.state.model.jwt`) into `params` for every RPC except the pre-auth ones listed in its `omitRpcs`. If the JWT is expired it pushes `Routes.authInitRoute` to force re-authentication before continuing. Any new pre-auth RPC must be added to `omitRpcs`.

### Crypto and secrets

`lib/core/utils/security_utils.dart` is the whole crypto surface: PBKDF2-HMAC-SHA256 (100k iterations, run in an `Isolate`) derives a master key from the master password + per-user salt; `hashMasterKey` (SHA-256 → base64) is what the server verifies; `encryptPassword`/`decryptPassword` do AES-CBC with the derived key, serialized as `base64(iv):base64(ciphertext)`. Plaintext secrets never reach the backend.

The derived key lives in memory in `ProfileBloc.state.model.derivedKey` (a `Uint8List`) and is the decryption key for every stored password/card. In `flutter_secure_storage` the *storage keys themselves* are secrets from the env: `Env.derivedKey` and `Env.biometricHashKey` are the key names, not the values — see `biometric_utils.dart`, `auth_init_bloc.dart`, `biometric_bloc.dart`, `master_password_bloc.dart`.

### UI

Theming and shared components come from the external `atomic_design_system` package (git dependency on `judatop/atomic_design_system`, `master`) — `ADSTheme.lightTheme`/`darkTheme` are applied in `lib/app/app_widget.dart`, driven by `PreferencesBloc`. Localization is en/es via `lib/l10n/app_*.arb` (`flutter gen-l10n`, config in `l10n.yaml`); user-facing strings belong in the `.arb` files.

### Docs and explanation of How SavePass Works
Check https://landing.savepass.app/docs