import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:ui_web' as ui;
import 'package:universal_html/html.dart';

class PruebaView extends StatefulWidget {
  const PruebaView({super.key});

  @override
  State<PruebaView> createState() => _PruebaViewState();
}

class _PruebaViewState extends State<PruebaView> {
  String time = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Text(time),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1)),
            width: 400,
            height: 60,
            child: HtmlAudio(
              id: 'horse.ogg',
              onChangeAudioTime: _onChangeAudioTime,
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Player.play('');
              },
              child: const Text('Play')),
        ],
      )),
    );
  }

  void _onChangeAudioTime(String currentTime) {
    setState(() {
      time = currentTime;
    });
  }
}

class HtmlAudio extends StatelessWidget {
  final void Function(String currentTime) onChangeAudioTime;
  final String id;

  HtmlAudio({super.key, required this.id, required this.onChangeAudioTime}) {
    ui.platformViewRegistry.registerViewFactory('audio-$id', (int viewId) {
      AudioElement audioElement = AudioElement()
        ..addEventListener(
            'timeupdate',
            (event) => onChangeAudioTime(
                (event.target as AudioElement).currentTime.toString()))
        ..controls = true
        ..children.addAll([
          SourceElement()
            ..src =
                'https://drive.google.com/uc?export=view&id=146GCTUs9pUkm_3vIzdDCS-q_INWtWi5Q'
            ..type = 'audio/mp3',
        ]);
      audioElement.style.width = '100%';
      audioElement.style.height = '100%';

      return audioElement;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: 'audio-$id');
  }
}

class Player {
  static play(String src) async {
    final player = AudioPlayer();
  }
}
