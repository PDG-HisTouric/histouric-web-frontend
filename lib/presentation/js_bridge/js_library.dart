@JS()
library script.js;

import 'package:js/js.dart';

@JS()
external bool handleAuthClick(String apiKey, String appId);

@JS()
external void gapiLoaded();

@JS()
external void gisLoaded(String scopes, String clientId);

@JS()
external bool getIsPickerOpen();

@JS()
external List<List<dynamic>> getSelectedFilesInfo();

@JS()
external bool getIsThereAnError();
