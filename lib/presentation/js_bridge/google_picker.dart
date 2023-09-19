import 'package:histouric_web/domain/entities/histouric_image_info.dart';

import 'js_functions_google_picker.dart';

class GooglePicker {
  static void callFilePicker({
    required String apiKey,
    required String appId,
    required String mediaType,
  }) async {
    loginAndOpenPicker(apiKey, appId, mediaType);
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

  static bool callGetIsPickerOpen() {
    return getIsPickerOpen();
  }

  static String callGetSelectedAudioId() {
    return getSelectedAudioId();
  }

  static List<HistouricImageInfo> getSelectedImagesIds() {
    List<List<dynamic>> filesInfo = getSelectedImagesInfo();
    return filesInfo
        .map((fileInfo) => HistouricImageInfo.fromList(fileInfo))
        .toList();
  }

  static bool callGetIsThereAnError() {
    return getIsThereAnError();
  }
}
