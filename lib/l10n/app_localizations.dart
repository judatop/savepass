import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @getStartedTitle.
  ///
  /// In en, this message translates to:
  /// **'Store your passwords'**
  String get getStartedTitle;

  /// No description provided for @getStartedText.
  ///
  /// In en, this message translates to:
  /// **'Save all your passwords in one place'**
  String get getStartedText;

  /// No description provided for @getStartedSingIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get getStartedSingIn;

  /// No description provided for @getStartedSingUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get getStartedSingUp;

  /// No description provided for @authWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'with Google'**
  String get authWithGoogle;

  /// No description provided for @authWithApple.
  ///
  /// In en, this message translates to:
  /// **'with Apple'**
  String get authWithApple;

  /// No description provided for @authWithGithub.
  ///
  /// In en, this message translates to:
  /// **'with Github'**
  String get authWithGithub;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'with your email'**
  String get authEmail;

  /// No description provided for @signInNoAccount.
  ///
  /// In en, this message translates to:
  /// **'¿Don\'t have an account? Sign up'**
  String get signInNoAccount;

  /// No description provided for @signUpAlreadyAccount.
  ///
  /// In en, this message translates to:
  /// **'¿Already have an account? Sign in'**
  String get signUpAlreadyAccount;

  /// No description provided for @mandatoryField.
  ///
  /// In en, this message translates to:
  /// **'This field is mandatory'**
  String get mandatoryField;

  /// No description provided for @nameAtLeast3Characters.
  ///
  /// In en, this message translates to:
  /// **'The name must have at least 3 characters'**
  String get nameAtLeast3Characters;

  /// No description provided for @authTitle.
  ///
  /// In en, this message translates to:
  /// **'with your preferred authentication method'**
  String get authTitle;

  /// No description provided for @signUpButtonText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get signUpButtonText;

  /// No description provided for @byJoiningText.
  ///
  /// In en, this message translates to:
  /// **'By joining, you agree to our'**
  String get byJoiningText;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @incorrectEmail.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email'**
  String get incorrectEmail;

  /// No description provided for @authMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authMethodTitle;

  /// No description provided for @authMethodAndroidText.
  ///
  /// In en, this message translates to:
  /// **'Join using your fingerprint'**
  String get authMethodAndroidText;

  /// No description provided for @authMethodIosText.
  ///
  /// In en, this message translates to:
  /// **'Join using your Face ID'**
  String get authMethodIosText;

  /// No description provided for @nameSignUpForm.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameSignUpForm;

  /// No description provided for @emailSignUpForm.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailSignUpForm;

  /// No description provided for @masterPasswordSignUpForm.
  ///
  /// In en, this message translates to:
  /// **'Master Password'**
  String get masterPasswordSignUpForm;

  /// No description provided for @masterPasswordText.
  ///
  /// In en, this message translates to:
  /// **'Master Password is a secure password that you need to define in order to access to the application, it\'s important to remember it and keep it safe because it\'s your entry point to the app.'**
  String get masterPasswordText;

  /// No description provided for @optionalForm.
  ///
  /// In en, this message translates to:
  /// **'(Optional)'**
  String get optionalForm;

  /// No description provided for @atLeast8Characters.
  ///
  /// In en, this message translates to:
  /// **'The password must have at least 8 characters'**
  String get atLeast8Characters;

  /// No description provided for @containsLowerCase.
  ///
  /// In en, this message translates to:
  /// **'The password must contain at least one lowercase letter'**
  String get containsLowerCase;

  /// No description provided for @containsUpperCase.
  ///
  /// In en, this message translates to:
  /// **'The password must contain at least one uppercase letter'**
  String get containsUpperCase;

  /// No description provided for @containsNumber.
  ///
  /// In en, this message translates to:
  /// **'The password must contain at least one number'**
  String get containsNumber;

  /// No description provided for @containsSpecialCharacter.
  ///
  /// In en, this message translates to:
  /// **'The password must contain at least one special character'**
  String get containsSpecialCharacter;

  /// No description provided for @notContains3RepeatedCharacters.
  ///
  /// In en, this message translates to:
  /// **'The password must not contain 3 repeated characters'**
  String get notContains3RepeatedCharacters;

  /// No description provided for @notContains3ConsecutiveCharacters.
  ///
  /// In en, this message translates to:
  /// **'The password must not contain 3 consecutive characters'**
  String get notContains3ConsecutiveCharacters;

  /// No description provided for @photoAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo access required'**
  String get photoAccessTitle;

  /// No description provided for @photoAccessText.
  ///
  /// In en, this message translates to:
  /// **'It is necessary to grant access permissions to the gallery, this will allow you to select a profile picture for your account.'**
  String get photoAccessText;

  /// No description provided for @photoAccessButton.
  ///
  /// In en, this message translates to:
  /// **'Grant access'**
  String get photoAccessButton;

  /// No description provided for @permanentTitle.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get permanentTitle;

  /// No description provided for @permanentText.
  ///
  /// In en, this message translates to:
  /// **'You have permanently denied access to the gallery, in order to select a profile picture for your account, you must grant access permissions to the gallery from your device settings.'**
  String get permanentText;

  /// No description provided for @permanentButton.
  ///
  /// In en, this message translates to:
  /// **'Understood'**
  String get permanentButton;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'The email is already in use'**
  String get emailAlreadyInUse;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalidCredentials;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred, please try again later'**
  String get genericError;

  /// No description provided for @actionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Action needed'**
  String get actionNeeded;

  /// No description provided for @authBiometricMsg.
  ///
  /// In en, this message translates to:
  /// **'Please authenticate to continue'**
  String get authBiometricMsg;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @authInitText.
  ///
  /// In en, this message translates to:
  /// **'Please, enter your master password'**
  String get authInitText;

  /// No description provided for @useBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Use biometrics'**
  String get useBiometrics;

  /// No description provided for @passwordTitle.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get passwordTitle;

  /// No description provided for @passwordEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit password'**
  String get passwordEditTitle;

  /// No description provided for @registerMasterPassword.
  ///
  /// In en, this message translates to:
  /// **'Register your master password'**
  String get registerMasterPassword;

  /// No description provided for @enterMasterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your master password'**
  String get enterMasterPassword;

  /// No description provided for @signInDesc.
  ///
  /// In en, this message translates to:
  /// **'Sign in to SavePass with your email and password'**
  String get signInDesc;

  /// No description provided for @avatar.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get avatar;

  /// No description provided for @avatarDesc.
  ///
  /// In en, this message translates to:
  /// **'Click to change your avatar'**
  String get avatarDesc;

  /// No description provided for @avatarManagedByProviderDesc.
  ///
  /// In en, this message translates to:
  /// **'Your avatar is managed by the authentication provider'**
  String get avatarManagedByProviderDesc;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get accountSettings;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// No description provided for @displayNameDesc.
  ///
  /// In en, this message translates to:
  /// **'Optional: Your name will be displayed in the app'**
  String get displayNameDesc;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose the theme that best suits you'**
  String get themeDesc;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @appLanguageDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get appLanguageDesc;

  /// No description provided for @chooseOption.
  ///
  /// In en, this message translates to:
  /// **'Choose an option'**
  String get chooseOption;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyTitle;

  /// No description provided for @termsAuthTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get termsAuthTitle;

  /// No description provided for @privacyText.
  ///
  /// In en, this message translates to:
  /// **'Check our privacy policy'**
  String get privacyText;

  /// No description provided for @openPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Open Privacy Policy'**
  String get openPrivacy;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsTitle;

  /// No description provided for @termsText.
  ///
  /// In en, this message translates to:
  /// **'Check our terms and conditions'**
  String get termsText;

  /// No description provided for @openTerms.
  ///
  /// In en, this message translates to:
  /// **'Open Terms'**
  String get openTerms;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @rateIt.
  ///
  /// In en, this message translates to:
  /// **'Rate it'**
  String get rateIt;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

  /// No description provided for @deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteTitle;

  /// No description provided for @deleteText.
  ///
  /// In en, this message translates to:
  /// **'By deleting your account, all your data will be permanently deleted and you will not be able to recover it.'**
  String get deleteText;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteButton;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @toolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get toolsTitle;

  /// No description provided for @attentionTitle.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get attentionTitle;

  /// No description provided for @attentionText.
  ///
  /// In en, this message translates to:
  /// **'By accepting, your account will be deleted and you will not be able to recover it.'**
  String get attentionText;

  /// No description provided for @acceptButton.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get acceptButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @homeSearch.
  ///
  /// In en, this message translates to:
  /// **'Search by password or card'**
  String get homeSearch;

  /// No description provided for @passwordGenerated.
  ///
  /// In en, this message translates to:
  /// **'Password generated'**
  String get passwordGenerated;

  /// No description provided for @passwordType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get passwordType;

  /// No description provided for @passwordTypeAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get passwordTypeAuto;

  /// No description provided for @passName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get passName;

  /// No description provided for @passNameHint.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get passNameHint;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username/Mail'**
  String get username;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'judatop'**
  String get usernameHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'********'**
  String get passwordHint;

  /// No description provided for @passDesc.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get passDesc;

  /// No description provided for @domain.
  ///
  /// In en, this message translates to:
  /// **'Domain'**
  String get domain;

  /// No description provided for @domainHint.
  ///
  /// In en, this message translates to:
  /// **'instagram.com'**
  String get domainHint;

  /// No description provided for @passwordCreated.
  ///
  /// In en, this message translates to:
  /// **'Password saved'**
  String get passwordCreated;

  /// No description provided for @tipDashboard.
  ///
  /// In en, this message translates to:
  /// **'Press and hold a card to copy'**
  String get tipDashboard;

  /// No description provided for @passwordsTitleDashboard.
  ///
  /// In en, this message translates to:
  /// **'Passwords'**
  String get passwordsTitleDashboard;

  /// No description provided for @toolTipAddPassword.
  ///
  /// In en, this message translates to:
  /// **'Add a new password'**
  String get toolTipAddPassword;

  /// No description provided for @saveText.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveText;

  /// No description provided for @editText.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editText;

  /// No description provided for @passwordCopiedClipboard.
  ///
  /// In en, this message translates to:
  /// **'Password copied to clipboard'**
  String get passwordCopiedClipboard;

  /// No description provided for @noPasswordsCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'No passwords created'**
  String get noPasswordsCreatedTitle;

  /// No description provided for @noPasswordsCreatedText.
  ///
  /// In en, this message translates to:
  /// **'Tap to add a new password'**
  String get noPasswordsCreatedText;

  /// No description provided for @userCopiedClipboard.
  ///
  /// In en, this message translates to:
  /// **'User copied to clipboard'**
  String get userCopiedClipboard;

  /// No description provided for @cardMinLength.
  ///
  /// In en, this message translates to:
  /// **'The card number must have at least 16 digits'**
  String get cardMinLength;

  /// No description provided for @newCardTitle.
  ///
  /// In en, this message translates to:
  /// **'New card'**
  String get newCardTitle;

  /// No description provided for @editCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit card'**
  String get editCardTitle;

  /// No description provided for @cardValid.
  ///
  /// In en, this message translates to:
  /// **'VALID'**
  String get cardValid;

  /// No description provided for @cardUntil.
  ///
  /// In en, this message translates to:
  /// **'UNTIL'**
  String get cardUntil;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// No description provided for @cardholderName.
  ///
  /// In en, this message translates to:
  /// **'Cardholder Name'**
  String get cardholderName;

  /// No description provided for @cardholderHint.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get cardholderHint;

  /// No description provided for @cardExpiration.
  ///
  /// In en, this message translates to:
  /// **'Expiration Date'**
  String get cardExpiration;

  /// No description provided for @cardCvv.
  ///
  /// In en, this message translates to:
  /// **'Card Security Code (CVV)'**
  String get cardCvv;

  /// No description provided for @cvvMinLength.
  ///
  /// In en, this message translates to:
  /// **'The CVV must have at least 3 digits'**
  String get cvvMinLength;

  /// No description provided for @cardExpMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 2 digits'**
  String get cardExpMinLength;

  /// No description provided for @cardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get cardsTitle;

  /// No description provided for @deletePasswordText.
  ///
  /// In en, this message translates to:
  /// **'By deleting this password, you will not be able to recover it.'**
  String get deletePasswordText;

  /// No description provided for @passwordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Password deleted'**
  String get passwordDeleted;

  /// No description provided for @cardCreated.
  ///
  /// In en, this message translates to:
  /// **'Card created successfully'**
  String get cardCreated;

  /// No description provided for @noCardsCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'No cards created'**
  String get noCardsCreatedTitle;

  /// No description provided for @noCardsCreatedText.
  ///
  /// In en, this message translates to:
  /// **'Tap to add a new card'**
  String get noCardsCreatedText;

  /// No description provided for @toolTipAddCard.
  ///
  /// In en, this message translates to:
  /// **'Add a new card'**
  String get toolTipAddCard;

  /// No description provided for @deleteCardText.
  ///
  /// In en, this message translates to:
  /// **'By deleting this card, you will not be able to recover it.'**
  String get deleteCardText;

  /// No description provided for @cardDeleted.
  ///
  /// In en, this message translates to:
  /// **'Card deleted'**
  String get cardDeleted;

  /// No description provided for @cardValueCopiedClipboard.
  ///
  /// In en, this message translates to:
  /// **'Card value copied to clipboard'**
  String get cardValueCopiedClipboard;

  /// No description provided for @copyValueCardTooltip.
  ///
  /// In en, this message translates to:
  /// **'Press a value to copy it'**
  String get copyValueCardTooltip;

  /// No description provided for @cardEdited.
  ///
  /// In en, this message translates to:
  /// **'Card updated successfully'**
  String get cardEdited;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @cardNumberCopiedClipboard.
  ///
  /// In en, this message translates to:
  /// **'Card Number copied to clipboard'**
  String get cardNumberCopiedClipboard;

  /// No description provided for @cardholderNameCopiedClipboard.
  ///
  /// In en, this message translates to:
  /// **'Cardholder Name copied to clipboard'**
  String get cardholderNameCopiedClipboard;

  /// No description provided for @searchPassReport.
  ///
  /// In en, this message translates to:
  /// **'Search by name or username'**
  String get searchPassReport;

  /// No description provided for @searchCardReport.
  ///
  /// In en, this message translates to:
  /// **'Search by type'**
  String get searchCardReport;

  /// No description provided for @successfullyLink.
  ///
  /// In en, this message translates to:
  /// **'Linked successfully'**
  String get successfullyLink;

  /// No description provided for @deviceNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'Device not registered'**
  String get deviceNotRegistered;

  /// No description provided for @currentSessionWith.
  ///
  /// In en, this message translates to:
  /// **'You have a registered session with '**
  String get currentSessionWith;

  /// No description provided for @wantToLink.
  ///
  /// In en, this message translates to:
  /// **'If you want to continue with this device, you can register it and we will unlink the previous one.'**
  String get wantToLink;

  /// No description provided for @linkDevice.
  ///
  /// In en, this message translates to:
  /// **'Register device'**
  String get linkDevice;

  /// No description provided for @enableBiometricsTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable your biometrics'**
  String get enableBiometricsTitle;

  /// No description provided for @enableBiometricsText.
  ///
  /// In en, this message translates to:
  /// **'By activating your biometrics, you do not need to enter your master password at every sign in.'**
  String get enableBiometricsText;

  /// No description provided for @biometrics.
  ///
  /// In en, this message translates to:
  /// **'Biometrics'**
  String get biometrics;

  /// No description provided for @biometricsTip.
  ///
  /// In en, this message translates to:
  /// **'Sign in with biometrics for a faster experience'**
  String get biometricsTip;

  /// No description provided for @biometricsEnrolled.
  ///
  /// In en, this message translates to:
  /// **'Biometrics enrolled successfully'**
  String get biometricsEnrolled;

  /// No description provided for @updateMasterPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Update master password'**
  String get updateMasterPasswordTitle;

  /// No description provided for @updateMasterPasswordText.
  ///
  /// In en, this message translates to:
  /// **'We recommend updating your master password periodically for security reasons.'**
  String get updateMasterPasswordText;

  /// No description provided for @updateText.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateText;

  /// No description provided for @enterOldMasterPassword.
  ///
  /// In en, this message translates to:
  /// **'Old master password'**
  String get enterOldMasterPassword;

  /// No description provided for @enterNewMasterPassword.
  ///
  /// In en, this message translates to:
  /// **'New master password'**
  String get enterNewMasterPassword;

  /// No description provided for @repeatMasterPassword.
  ///
  /// In en, this message translates to:
  /// **'Repeat new master password'**
  String get repeatMasterPassword;

  /// No description provided for @passwordMissmatch.
  ///
  /// In en, this message translates to:
  /// **'The passwords do not match'**
  String get passwordMissmatch;

  /// No description provided for @masterPasswordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Master password updated successfully'**
  String get masterPasswordUpdated;

  /// No description provided for @newPasswordBeDiferent.
  ///
  /// In en, this message translates to:
  /// **'New password needs to be different'**
  String get newPasswordBeDiferent;

  /// No description provided for @maxLengthField.
  ///
  /// In en, this message translates to:
  /// **'Field value too large'**
  String get maxLengthField;

  /// No description provided for @repeatPassword.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get repeatPassword;

  /// No description provided for @reachedPasswordsLimit.
  ///
  /// In en, this message translates to:
  /// **'Reached passwords limit number'**
  String get reachedPasswordsLimit;

  /// No description provided for @reachedCardsLimit.
  ///
  /// In en, this message translates to:
  /// **'Reached cards limit number'**
  String get reachedCardsLimit;

  /// No description provided for @userBlocked.
  ///
  /// In en, this message translates to:
  /// **'User blocked'**
  String get userBlocked;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordText.
  ///
  /// In en, this message translates to:
  /// **'Please enter the email address associated with your account so we can send you the details to change your password.'**
  String get forgotPasswordText;

  /// No description provided for @checkYourMailTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your mail'**
  String get checkYourMailTitle;

  /// No description provided for @recoveryPasswordSent.
  ///
  /// In en, this message translates to:
  /// **'If there is a SavePass account associated with the email address you entered, you will receive instructions on how to recover your password.'**
  String get recoveryPasswordSent;

  /// No description provided for @newPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordTitle;

  /// No description provided for @newPasswordText.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password to regain access to your account.'**
  String get newPasswordText;

  /// No description provided for @newPasswordMustBeDiferent.
  ///
  /// In en, this message translates to:
  /// **'The new password must be different from the previous ones'**
  String get newPasswordMustBeDiferent;

  /// No description provided for @emailInvalidExpired.
  ///
  /// In en, this message translates to:
  /// **'Email link is invalid or has expired'**
  String get emailInvalidExpired;

  /// No description provided for @signUpCheckMailText.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent you a confirmation link. Please check your inbox and click the link to verify your account. If you don\'t see it, be sure to check your spam or promotions folder.'**
  String get signUpCheckMailText;

  /// No description provided for @emailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Your email is not confirmed'**
  String get emailNotConfirmed;

  /// No description provided for @masterPasswordNotRecovered.
  ///
  /// In en, this message translates to:
  /// **'If you lose your master password, you will lose access to your data. You can not recover it.'**
  String get masterPasswordNotRecovered;

  /// No description provided for @weAreExpectingSomeIssues.
  ///
  /// In en, this message translates to:
  /// **'We are experiencing some issues with the app. Please be patient while we work on it.'**
  String get weAreExpectingSomeIssues;

  /// No description provided for @weApologize.
  ///
  /// In en, this message translates to:
  /// **'Our apologies'**
  String get weApologize;

  /// No description provided for @newVersionAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'New version available'**
  String get newVersionAvailableTitle;

  /// No description provided for @newVersionAvailableText.
  ///
  /// In en, this message translates to:
  /// **'A new version of the app is available. Please update to the latest version for the best experience.'**
  String get newVersionAvailableText;

  /// No description provided for @newVersionAvailableDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get newVersionAvailableDownload;

  /// No description provided for @savepassDocs.
  ///
  /// In en, this message translates to:
  /// **'Docs'**
  String get savepassDocs;

  /// No description provided for @goBackText.
  ///
  /// In en, this message translates to:
  /// **'Your changes have not been saved. Do you want to go back?'**
  String get goBackText;

  /// No description provided for @logoutText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutText;

  /// No description provided for @lengthText.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get lengthText;

  /// No description provided for @easyToReadText.
  ///
  /// In en, this message translates to:
  /// **'Easy to read'**
  String get easyToReadText;

  /// No description provided for @uppwerLowerCaseText.
  ///
  /// In en, this message translates to:
  /// **'Upper and lower case'**
  String get uppwerLowerCaseText;

  /// No description provided for @numbersText.
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get numbersText;

  /// No description provided for @symbolsText.
  ///
  /// In en, this message translates to:
  /// **'Symbols'**
  String get symbolsText;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
