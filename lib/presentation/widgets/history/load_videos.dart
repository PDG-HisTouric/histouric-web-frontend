import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../../../domain/entities/entities.dart';
import '../../js_bridge/js_bridge.dart';
import '../video/video.dart';

class LoadVideos extends StatefulWidget {
  const LoadVideos({super.key});

  @override
  State<LoadVideos> createState() => _LoadVideosState();
}

class _LoadVideosState extends State<LoadVideos> {
  List<Uint8List> videos = [];
  List<String> videosNames = [];
  List<String> selectedVideos = [];
  List<String> videosExtensions = [];
  bool isVideoFromFilePicker = false;
  List<HistouricVideoInfo> videosInfo = [];
  AbstractFilePicker filePicker = FilePickerImpl();

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
            isVideoFromFilePicker = false;
            videosInfo = GooglePicker.getInfoOfSelectedVideos();
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isVideoFromFilePicker)
          Wrap(
            children: [
              for (int i = 0; i < videos.length; i++)
                HtmlVideoFromUint8List(
                  uint8List: videos[i],
                  extension: videosExtensions[i],
                ),
            ],
          ),
        if (!isVideoFromFilePicker)
          Wrap(
            children: videosInfo
                .map(
                  (videoInfo) => HtmlVideoContainer(url: videoInfo.url),
                )
                .toList(),
          ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () {
                filePicker.selectVideos().then((result) {
                  setState(() {
                    videos = result.$1;
                    videosExtensions = result.$2;
                    videosNames = result.$3;
                    isVideoFromFilePicker = true;
                  });
                });
              },
              label: const Text("From File Explorer"),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: _loadVideoFromDrive,
              label: const Text("From Google Drive"),
            ),
          ],
        ),
      ],
    );
  }
}
