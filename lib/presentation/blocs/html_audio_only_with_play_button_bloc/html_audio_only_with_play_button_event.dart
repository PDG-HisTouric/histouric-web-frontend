part of 'html_audio_only_with_play_button_bloc.dart';

abstract class HtmlAudioOnlyWithPlayButtonEvent {}

class PlayButtonPressed extends HtmlAudioOnlyWithPlayButtonEvent {
  PlayButtonPressed();
}

class PauseButtonPressed extends HtmlAudioOnlyWithPlayButtonEvent {
  PauseButtonPressed();
}

class AudioDurationChanged extends HtmlAudioOnlyWithPlayButtonEvent {
  final double audioDuration;

  AudioDurationChanged(this.audioDuration);
}

class AudioCurrentTimeChanged extends HtmlAudioOnlyWithPlayButtonEvent {
  final double currentTime;

  AudioCurrentTimeChanged(this.currentTime);
}
