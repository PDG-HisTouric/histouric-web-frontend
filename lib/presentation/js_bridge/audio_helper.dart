import 'js_functions_audio_helper.dart';

class AudioHelper {
  static double callGetDurationOfAudioById(String id) {
    return getDurationOfAudioById(id);
  }

  static void callPlayAudioById(String id) {
    playAudioById(id);
  }

  static void callPauseAudioById(String id) {
    pauseAudioById(id);
  }
}
