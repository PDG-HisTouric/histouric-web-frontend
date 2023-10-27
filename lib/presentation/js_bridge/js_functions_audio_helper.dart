@JS()
library script.js;

import 'package:js/js.dart';

@JS()
external double getDurationOfAudioById(String id);

@JS()
external void playAudioById(String id);

@JS()
external void pauseAudioById(String id);
