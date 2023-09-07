@JS()
library script.js;

import 'package:js/js.dart';

@JS()
external void handleAuthClick(String apiKey, String appId);

@JS()
external void gapiLoaded();

@JS()
external void gisLoaded(String scopes, String clientId);
