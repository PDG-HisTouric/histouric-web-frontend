import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';
import 'package:histouric_web/presentation/js_bridge/audio_helper.dart';
import 'package:universal_html/html.dart';

class HtmlAudioOnlyWithPlayButton extends StatelessWidget {
  final void Function(String currentTime)? onChangeAudioTime;
  final String audioId;
  const HtmlAudioOnlyWithPlayButton({
    super.key,
    this.onChangeAudioTime,
    required this.audioId,
  });

  @override
  Widget build(BuildContext context) {
    HtmlAudioOnlyWithPlayButtonState audioState =
        context.watch<HtmlAudioOnlyWithPlayButtonBloc>().state;
    bool isPlaying = audioState.isPlaying;

    return Row(
      children: [
        SizedBox(
          width: 0,
          height: 0,
          child: _HtmlAudio(
            audioId: audioId,
            audioUrl: context.read<HtmlAudioOnlyWithPlayButtonBloc>().audioUrl,
            onChangeAudioTime: (currentTime) {
              context
                  .read<HtmlAudioOnlyWithPlayButtonBloc>()
                  .changeAudioCurrentTime(
                    currentTime: double.parse(currentTime),
                  );
              if (onChangeAudioTime != null) onChangeAudioTime!(currentTime);
            },
          ),
        ),
        IconButton(
          onPressed: () {
            context
                .read<HtmlAudioOnlyWithPlayButtonBloc>()
                .initializeAudioDuration();
            if (isPlaying) {
              context
                  .read<HtmlAudioOnlyWithPlayButtonBloc>()
                  .clickPauseButton();
              AudioHelper.callPauseAudioById(audioId);
            } else {
              context.read<HtmlAudioOnlyWithPlayButtonBloc>().clickPlayButton();
              AudioHelper.callPlayAudioById(audioId);
            }
          },
          icon: Icon(audioState.icon),
        ),
      ],
    );
  }
}

class _HtmlAudio extends StatefulWidget {
  final String audioUrl;
  final String audioId;
  final void Function(String currentTime) onChangeAudioTime;

  _HtmlAudio({
    required this.audioUrl,
    required this.onChangeAudioTime,
    required this.audioId,
  }) {
    ui.platformViewRegistry.registerViewFactory(audioId, (int viewId) {
      AudioElement audioElement = AudioElement()
        ..controls = false
        ..id = audioId
        ..addEventListener(
            'timeupdate',
            (event) => onChangeAudioTime(
                (event.target as AudioElement).currentTime.toString()))
        ..children.addAll([SourceElement()..src = audioUrl]);
      audioElement.style.width = '100%';
      audioElement.style.height = '100%';
      return audioElement;
    });
  }

  @override
  State<_HtmlAudio> createState() => _HtmlAudioState();
}

class _HtmlAudioState extends State<_HtmlAudio> {
  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: widget.audioId);
  }
}
