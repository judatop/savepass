class DbUtils {
  static const profilesTable = 'profiles';
  static const publicParametersTable = 'public_parameters';
  static const passwordsParametersTable = 'passwords_parameters';
  static const cardParametersTable = 'card_parameters';
  static const passwordsTable = 'passwords';
  static const cardsTable = 'cards';

  static const hasMasterPasswordFunction = 'has_master_password';
  static const checkMasterPasswordFunction = 'check_master_password';
  static const deviceNameFunction = 'get_device_name';
  static const enrollNewDeviceFunction = 'enroll_new_device';
  static const getUserSaltFunction = 'get_user_salt';
  static const isEmailExistsFunction = 'is_email_exist';
  static const insertMasterPassword = 'insert_master_password';
  static const updateMasterPassword = 'update_master_password';
  static const deleteAccountFunction = 'delete_account';
  static const enrollBiometricFunction = 'enroll_biometric';
  static const hasBiometricsFunction = 'has_biometrics';

  static const insertPasswordFunction = 'insert_password';
  static const editPasswordFunction = 'edit_password';
  static const deletepasswordFunction = 'delete_password';
  static const getPasswordsFunction = 'get_passwords';
  static const getPasswordByIdFunction = 'get_password_by_id';
  static const searchPasswordFunction = 'search_password';

  static const insertCardFunction = 'insert_card';
  static const editCardFunction = 'edit_card';
  static const deleteCardFunction = 'delete_card';
  static const getCardsFunction = 'get_cards';
  static const getCardByIdFunction = 'get_card_by_id';
  static const searchCardFunction = 'search_card';

  static const searchFunction = 'search';
}
