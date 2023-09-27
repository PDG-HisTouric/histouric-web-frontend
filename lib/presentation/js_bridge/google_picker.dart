import '../../domain/domain.dart';
import 'js_functions_google_picker.dart';

enum MediaType { audio, image, video }

class GooglePicker {
  static void callFilePicker({
    required String apiKey,
    required String appId,
    required MediaType mediaType,
  }) async {
    loginAndOpenPicker(apiKey, appId, mediaType.name);
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

  static String callGetSelectedAudioUrl() {
    return getSelectedAudioUrl();
  }

  static List<HistouricImageInfo> getInfoOfSelectedImages() {
    List<List<dynamic>> imagesInfo = getSelectedImagesInfo();
    return imagesInfo
        .map((imageInfo) => HistouricImageInfo.fromList(imageInfo))
        .toList();
  }

  static List<HistouricVideoInfo> getInfoOfSelectedVideos() {
    List<List<dynamic>> videosInfo = getSelectedVideosInfo();
    return videosInfo
        .map(
            (videoInfo) => HistouricVideoInfo.fromListOfGooglePicker(videoInfo))
        .toList();
  }

  static bool callGetIsThereAnError() {
    return getIsThereAnError();
  }

  static Future<void> waitUntilThePickerIsOpen() async {
    while (!callGetIsThereAnError() && !callGetIsPickerOpen()) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  static Future<void> waitUntilThePickerIsClosed() async {
    while (callGetIsPickerOpen()) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
}
