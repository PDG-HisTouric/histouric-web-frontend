@JS()
library script.js;

import 'package:js/js.dart';

@JS()
external String getPlatform();

// This function will do Promise to return something
@JS()
external dynamic jsPromiseFunction(String message);

// This function will open new popup window for given URL.
@JS()
external dynamic jsOpenTabFunction(String url);

@JS()
external void handleAuthClick(String apiKey, String appId);

@JS()
external void gapiLoaded();

@JS()
external void gisLoaded(String scopes, String clientId);
