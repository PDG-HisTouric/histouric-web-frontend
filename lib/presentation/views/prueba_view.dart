import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:histouric_web/config/constants/constants.dart';
import 'package:histouric_web/config/plugins/external_repositories/external_repositories.dart';
import 'package:histouric_web/presentation/js_bridge/js_bridge.dart';

import '../../config/helpers/snackbars.dart';
import '../../config/plugins/plugins.dart';
import '../../domain/entities/entities.dart';
import '../widgets/audio/audio.dart';
import '../widgets/widgets.dart';

class PruebaView extends StatefulWidget {
  const PruebaView({super.key});

  @override
  State<PruebaView> createState() => _PruebaViewState();
}

class _PruebaViewState extends State<PruebaView> {
  String time = '';
  String src = '';
  List<HistouricVideoInfo> videosInfo = [];
  AbstractFilePicker filePicker = FilePickerImpl();
  List<Uint8List> images = [];
  List<String> imagesExtensions = [];
  List<Uint8List> videos = [];
  List<String> videosExtensions = [];
  Uint8List? audio;
  String? audioExtension;
  List<String> imagesFromFirebase = [];
  List<String> videosFromFirebase = [];
  List<String> audiosFromFirebase = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(time),
            HtmlAudioContainer(
              src: src,
              width: 400,
              onChangeAudioTime: _onChangeAudioTime,
            ),
            ElevatedButton(
              onPressed: () {
                _loadAudioFromDrive();
              },
              child: const Text('Cargar audio de Drive'),
            ),
            ElevatedButton(
              onPressed: () {
                _loadVideoFromDrive();
              },
              child: const Text('Cargar video de Drive'),
            ),
            Column(
              children: videosInfo
                  .map(
                    (videoInfo) => Row(
                      children: [
                        const Spacer(),
                        HtmlVideoContainer(
                          url: videoInfo.url,
                        ),
                        const Spacer(),
                      ],
                    ),
                  )
                  .toList(),
            ),
            Wrap(
              children: [
                for (int i = 0; i < images.length; i++)
                  HtmlImageFromUint8List(
                    uint8List: images[i],
                    extension: imagesExtensions[i],
                  ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await filePicker.selectImages();
                setState(() {
                  images = result.$1;
                  imagesExtensions = result.$2;
                });
              },
              child: const Text('Abrir file picker de imágenes'),
            ),
            Wrap(
              children: [
                for (int i = 0; i < imagesFromFirebase.length; i++)
                  RoundedHtmlImage(
                    imageId: imagesFromFirebase[i],
                    isFromDrive: false,
                  ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                final ExternalRepository firebaseRepository =
                    FirebaseRepository();
                for (int i = 0; i < images.length; i++) {
                  firebaseRepository
                      .uploadImage(
                    'image$i.${imagesExtensions[i]}',
                    images[i],
                  )
                      .then((url) {
                    if (url != null) {
                      SnackBars.showInfoSnackBar(
                        context,
                        'Imagen $i subida a Firebase',
                      );
                    }
                    setState(() {
                      if (url != null) imagesFromFirebase.add(url);
                    });
                  });
                }
              },
              child: const Text('Subir imágenes a Firebase'),
            ),
            Wrap(
              children: [
                for (int i = 0; i < videos.length; i++)
                  HtmlVideoFromUint8List(
                    uint8List: videos[i],
                    extension: videosExtensions[i],
                  ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                filePicker.selectVideos().then((result) {
                  setState(() {
                    videos = result.$1;
                    videosExtensions = result.$2;
                  });
                });
              },
              child: const Text('Abrir file picker de videos'),
            ),
            Wrap(
              children: [
                for (int i = 0; i < videosFromFirebase.length; i++)
                  HtmlVideoContainer(
                    url: videosFromFirebase[i],
                  ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                final ExternalRepository firebaseRepository =
                    FirebaseRepository();
                for (int i = 0; i < videos.length; i++) {
                  firebaseRepository
                      .uploadVideo(
                    'video$i.${videosExtensions[i]}',
                    videos[i],
                  )
                      .then((url) {
                    if (url != null) {
                      SnackBars.showInfoSnackBar(
                        context,
                        'Video $i subido a Firebase',
                      );
                    }
                    setState(() {
                      if (url != null) videosFromFirebase.add(url);
                    });
                  });
                }
              },
              child: const Text('Subir videos a Firebase'),
            ),
            if (audio != null)
              HtmlAudioFromUint8List(
                uint8List: audio!,
                extension: audioExtension!,
                width: 400,
                onChangeAudioTime: _onChangeAudioTime,
              ),
            ElevatedButton(
              onPressed: () {
                filePicker.selectAudio().then((result) {
                  setState(() {
                    audio = result.$1;
                    audioExtension = result.$2;
                  });
                });
              },
              child: const Text('Abrir file picker de audio'),
            ),
            Wrap(
              children: [
                for (int i = 0; i < audiosFromFirebase.length; i++)
                  HtmlAudioContainer(
                    src: audiosFromFirebase[i],
                    width: 400,
                    onChangeAudioTime: _onChangeAudioTime,
                  ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                final ExternalRepository firebaseRepository =
                    FirebaseRepository();
                firebaseRepository
                    .uploadAudio(
                  'audio${audioExtension!}',
                  audio!,
                )
                    .then((url) {
                  if (url != null) {
                    SnackBars.showInfoSnackBar(
                      context,
                      'Audio subido a Firebase',
                    );
                  }
                  setState(() {
                    if (url != null) audiosFromFirebase.add(url);
                  });
                });
              },
              child: const Text('Subir audio a Firebase'),
            ),
          ],
        ),
      ),
    );
  }

  void _onChangeAudioTime(String currentTime) {
    setState(() {
      time = currentTime;
    });
  }

  void _loadAudioFromDrive() {
    GooglePicker.callFilePicker(
      apiKey: Environment.pickerApiKey,
      appId: Environment.pickerApiAppId,
      mediaType: MediaType.audio,
    );

    _waitUntilThePickerIsOpen().then((value) {
      _waitUntilThePickerIsClosed().then((value) {
        if (!GooglePicker.callGetIsThereAnError()) {
          final audioId = GooglePicker.callGetSelectedAudioId();
          setState(() {
            src = 'https://drive.google.com/uc?export=download&id=$audioId';
          });
        }
      });
    });
  }

  void _loadVideoFromDrive() {
    GooglePicker.callFilePicker(
      apiKey: Environment.pickerApiKey,
      appId: Environment.pickerApiAppId,
      mediaType: MediaType.video,
    );

    GooglePicker.waitUntilThePickerIsOpen().then((value) {
      GooglePicker.waitUntilThePickerIsClosed().then((value) {
        if (!GooglePicker.callGetIsThereAnError()) {
          setState(() {
            videosInfo = GooglePicker.getInfoOfSelectedVideos();
          });
        }
      });
    });
  }

  Future<void> _waitUntilThePickerIsOpen() async {
    while (!GooglePicker.callGetIsThereAnError() &&
        !GooglePicker.callGetIsPickerOpen()) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> _waitUntilThePickerIsClosed() async {
    while (GooglePicker.callGetIsPickerOpen()) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
}
