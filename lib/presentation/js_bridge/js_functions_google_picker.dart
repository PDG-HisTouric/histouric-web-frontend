@JS()
library script.js;

import 'package:js/js.dart';

@JS()
external bool loginAndOpenPicker(String apiKey, String appId, String mediaType);

@JS()
external void gapiLoaded();

@JS()
external void gisLoaded(String scopes, String clientId);

@JS()
external bool getIsPickerOpen();

@JS()
external List<List<dynamic>> getSelectedImagesInfo();

@JS()
external String getSelectedAudioId();

@JS()
external List<List<dynamic>> getSelectedVideosInfo();

@JS()
external bool getIsThereAnError();
