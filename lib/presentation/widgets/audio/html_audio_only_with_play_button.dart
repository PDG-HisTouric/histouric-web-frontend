import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';
import 'package:histouric_web/presentation/js_bridge/audio_helper.dart';
import 'package:universal_html/html.dart';

class HtmlAudioOnlyWithPlayButton extends StatelessWidget {
  final void Function(String currentTime)? onChangeAudioTime;
  const HtmlAudioOnlyWithPlayButton({super.key, this.onChangeAudioTime});

  final double _currentTime = 0;

  void _changeCurrentTime(String currentTime) {
    // setState(() {
    //   _currentTime = double.parse(currentTime);
    // });
    // _currentTime = double.parse(currentTime);
    // print("$_currentTime == $_audioDuration");
  }

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
            String src =
                context.read<HtmlAudioOnlyWithPlayButtonBloc>().audioUrl;
            context
                .read<HtmlAudioOnlyWithPlayButtonBloc>()
                .initializeAudioDuration();
            if (isPlaying) {
              context
                  .read<HtmlAudioOnlyWithPlayButtonBloc>()
                  .clickPauseButton();
              AudioHelper.callPauseAudioById("audio-$src");
            } else {
              context.read<HtmlAudioOnlyWithPlayButtonBloc>().clickPlayButton();
              AudioHelper.callPlayAudioById("audio-$src");
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
  final void Function(String currentTime) onChangeAudioTime;

  _HtmlAudio({
    super.key,
    required this.audioUrl,
    required this.onChangeAudioTime,
  }) {
    ui.platformViewRegistry.registerViewFactory('audio-$audioUrl',
        (int viewId) {
      AudioElement audioElement = AudioElement()
        ..controls = false
        ..id = 'audio-$audioUrl'
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
    return HtmlElementView(viewType: 'audio-${widget.audioUrl}');
  }
}
