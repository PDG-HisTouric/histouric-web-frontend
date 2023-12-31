class Environment {
  static String pickerApiScopes =
      const String.fromEnvironment('SCOPES', defaultValue: 'SCOPES not found');
  static String pickerApiClientId = const String.fromEnvironment('CLIENT_ID',
      defaultValue: 'CLIENT_ID not found');
  static String pickerApiKey = const String.fromEnvironment(
      'PICKER_AND_DRIVE_API_KEY',
      defaultValue: 'API_KEY not found');
  static String pickerApiAppId =
      const String.fromEnvironment('APP_ID', defaultValue: 'APP_ID not found');
  static String baseUrl = const String.fromEnvironment('BASE_URL',
      defaultValue: 'BASE_URL not found');
}
