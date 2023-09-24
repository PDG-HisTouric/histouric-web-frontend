class Environment {
  static String pickerApiScopes =
      const String.fromEnvironment('SCOPES', defaultValue: 'SCOPES not found');
  static String pickerApiClientId = const String.fromEnvironment('CLIENT_ID',
      defaultValue: 'CLIENT_ID not found');
  static String pickerApiKey = const String.fromEnvironment('API_KEY',
      defaultValue: 'API_KEY not found');
  static String pickerApiAppId =
      const String.fromEnvironment('APP_ID', defaultValue: 'APP_ID not found');
  static String baseUrl = const String.fromEnvironment('BASE_URL',
      defaultValue: 'BASE_URL not found');
  static String directionsApiKey = const String.fromEnvironment(
      'DIRECTIONS_API_KEY',
      defaultValue: 'DIRECTIONS_API_KEY not found');
  static String firebaseApiKey = const String.fromEnvironment(
      'FIREBASE_API_KEY',
      defaultValue: 'FIREBASE_API_KEY not found');
  static String firebaseAppId = const String.fromEnvironment('FIREBASE_APP_ID',
      defaultValue: 'FIREBASE_APP_ID not found');
  static String firebaseMessagingSenderId = const String.fromEnvironment(
      'FIREBASE_MESSAGING_SENDER_ID',
      defaultValue: 'FIREBASE_MESSAGING_SENDER_ID not found');
  static String firebaseProjectId = const String.fromEnvironment(
      'FIREBASE_PROJECT_ID',
      defaultValue: 'FIREBASE_PROJECT_ID not found');
  static String firebaseAuthDomain = const String.fromEnvironment(
      'FIREBASE_AUTH_DOMAIN',
      defaultValue: 'FIREBASE_AUTH_DOMAIN not found');
  static String firebaseStorageBucket = const String.fromEnvironment(
      'FIREBASE_STORAGE_BUCKET',
      defaultValue: 'FIREBASE_STORAGE_BUCKET not found');
}
