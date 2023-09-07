import 'package:js/js_util.dart';

import 'js_library.dart';

class JSHelper {
  static void callFilePicker({
    required String apiKey,
    required String appId,
  }) async {
    handleAuthClick(apiKey, appId);
  }

  static void callGapiLoaded() {
    gapiLoaded();
  }

  static void callGisLoaded({
    required String scopes,
    required String clientId,
  }) {
    gisLoaded(scopes, clientId);
  }
}
