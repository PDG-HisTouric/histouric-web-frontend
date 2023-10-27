part of 'html_audio_only_with_play_button_bloc.dart';

class HtmlAudioOnlyWithPlayButtonState {
  final double audioDuration;
  final double currentTime;
  final IconData icon;
  final bool isPlaying;

  HtmlAudioOnlyWithPlayButtonState({
    this.audioDuration = 0,
    this.currentTime = 0,
    this.icon = Icons.play_arrow,
    this.isPlaying = false,
  });

  HtmlAudioOnlyWithPlayButtonState copyWith({
    double? audioDuration,
    double? currentTime,
    IconData? icon,
    bool? isPlaying,
  }) {
    return HtmlAudioOnlyWithPlayButtonState(
      audioDuration: audioDuration ?? this.audioDuration,
      currentTime: currentTime ?? this.currentTime,
      icon: icon ?? this.icon,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}
