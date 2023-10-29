import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../js_bridge/js_bridge.dart';

part 'html_audio_only_with_play_button_event.dart';
part 'html_audio_only_with_play_button_state.dart';

class HtmlAudioOnlyWithPlayButtonBloc extends Bloc<
    HtmlAudioOnlyWithPlayButtonEvent, HtmlAudioOnlyWithPlayButtonState> {
  final String audioUrl;
  final String htmlAudioId;
  HtmlAudioOnlyWithPlayButtonBloc({
    required this.audioUrl,
    required this.htmlAudioId,
  }) : super(HtmlAudioOnlyWithPlayButtonState()) {
    on<PlayButtonPressed>(_onPlayButtonPressed);
    on<PauseButtonPressed>(_onPauseButtonPressed);
    on<AudioDurationChanged>(_onAudioDurationChanged);
    on<AudioCurrentTimeChanged>(_onAudioCurrentTimeChanged);
    // const uuid = Uuid();
    // _audioId = "${uuid.v4()}-$audioUrl";
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
    emit(state.copyWith(audioDuration: event.audioDuration));
  }

  void initializeAudioDuration() {
    if (state.audioDuration != 0) return;
    double audioDuration = AudioHelper.callGetDurationOfAudioById(htmlAudioId);
    add(AudioDurationChanged(audioDuration));
  }

  void _onAudioCurrentTimeChanged(AudioCurrentTimeChanged event,
      Emitter<HtmlAudioOnlyWithPlayButtonState> emit) {
    emit(state.copyWith(currentTime: event.currentTime));
  }

  void changeAudioCurrentTime({required double currentTime}) {
    add(AudioCurrentTimeChanged(currentTime));
    if (currentTime == state.audioDuration) clickPauseButton();
  }
}
