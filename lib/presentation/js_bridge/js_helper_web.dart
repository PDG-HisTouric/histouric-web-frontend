import 'package:js/js_util.dart';

import 'js_library.dart';

class JSHelper {
  /// This method name inside 'getPlatform' should be same in JavaScript file
  static String getPlatformFromJS() {
    // return js.context.callMethod('getPlatform');
    return getPlatform();
  }

  static Future<String> callJSPromise() async {
    return await promiseToFuture(jsPromiseFunction("I am back from JS"));
  }

  static Future<String> callOpenTab() async {
    return await promiseToFuture(jsOpenTabFunction('https://google.com/'));
  }

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
