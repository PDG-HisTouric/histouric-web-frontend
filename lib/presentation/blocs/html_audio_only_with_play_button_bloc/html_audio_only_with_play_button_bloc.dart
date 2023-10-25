import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../js_bridge/js_bridge.dart';

part 'html_audio_only_with_play_button_event.dart';
part 'html_audio_only_with_play_button_state.dart';

class HtmlAudioOnlyWithPlayButtonBloc extends Bloc<
    HtmlAudioOnlyWithPlayButtonEvent, HtmlAudioOnlyWithPlayButtonState> {
  final String audioUrl;
  HtmlAudioOnlyWithPlayButtonBloc({required this.audioUrl})
      : super(HtmlAudioOnlyWithPlayButtonState()) {
    on<PlayButtonPressed>(_onPlayButtonPressed);
    on<PauseButtonPressed>(_onPauseButtonPressed);
    on<AudioDurationChanged>(_onAudioDurationChanged);
    on<AudioCurrentTimeChanged>(_onAudioCurrentTimeChanged);
  }

  void _onPlayButtonPressed(
      PlayButtonPressed event, Emitter<HtmlAudioOnlyWithPlayButtonState> emit) {
    emit(state.copyWith(icon: Icons.pause, isPlaying: true));
  }

  void clickPlayButton() {
    add(PlayButtonPressed());
  }

  void _onPauseButtonPressed(PauseButtonPressed event,
      Emitter<HtmlAudioOnlyWithPlayButtonState> emit) {
    emit(state.copyWith(icon: Icons.play_arrow, isPlaying: false));
  }

  void clickPauseButton() {
    add(PauseButtonPressed());
  }

  void _onAudioDurationChanged(AudioDurationChanged event,
      Emitter<HtmlAudioOnlyWithPlayButtonState> emit) {
    if (state.audioDuration != 0) return;
    print("audio duration == ${event.audioDuration}");
    emit(state.copyWith(audioDuration: event.audioDuration));
  }

  void initializeAudioDuration() {
    if (state.audioDuration != 0) return;
    double audioDuration =
        AudioHelper.callGetDurationOfAudioById("audio-$audioUrl");
    print("audio duration == $audioDuration");
    add(AudioDurationChanged(audioDuration));
  }

  void _onAudioCurrentTimeChanged(AudioCurrentTimeChanged event,
      Emitter<HtmlAudioOnlyWithPlayButtonState> emit) {
    emit(state.copyWith(currentTime: event.currentTime));
    print(state.currentTime);
  }

  void changeAudioCurrentTime({required double currentTime}) {
    add(AudioCurrentTimeChanged(currentTime));
    if (currentTime == state.audioDuration) clickPauseButton();
  }
}
