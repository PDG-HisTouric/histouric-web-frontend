import 'package:histouric_web/domain/entities/histouric_image_info.dart';
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

  static bool callGetIsPickerOpen() {
    return getIsPickerOpen();
  }

  static List<HistouricImageInfo> callGetSelectedFilesIds() {
    List<List<dynamic>> filesInfo = getSelectedFilesInfo();
    return filesInfo
        .map((fileInfo) => HistouricImageInfo.fromList(fileInfo))
        .toList();
  }

  static bool callGetIsThereAnError() {
    return getIsThereAnError();
  }
}
