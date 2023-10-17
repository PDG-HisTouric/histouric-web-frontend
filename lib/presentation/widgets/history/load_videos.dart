import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../blocs/blocs.dart';
import '../../js_bridge/js_bridge.dart';
import 'video_entry.dart';

class LoadVideos extends StatelessWidget {
  LoadVideos({super.key});
  final AbstractFilePicker filePicker = FilePickerImpl();

  void _loadVideoFromDrive(BuildContext context) {
    GooglePicker.callFilePicker(
      apiKey: Environment.pickerApiKey,
      appId: Environment.pickerApiAppId,
      mediaType: MediaType.video,
    );

    GooglePicker.waitUntilThePickerIsOpen().then((value) {
      GooglePicker.waitUntilThePickerIsClosed().then((value) {
        if (!GooglePicker.callGetIsThereAnError()) {
          final videosInfo = GooglePicker.getInfoOfSelectedVideos();
          for (var videoInfo in videosInfo) {
            context.read<HistoryBloc>().addVideoFromUrl(
                  url: videoInfo.url,
                  width: videoInfo.width,
                  height: videoInfo.height,
                );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoEntries = context
        .select((HistoryBloc historyBloc) => historyBloc.state.videoEntries);
    return Column(
      children: [
        Wrap(
          children: videoEntries,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () {
                filePicker.selectVideos().then((result) {
                  for (int i = 0; i < result.$1.length; i++) {
                    context.read<HistoryBloc>().addVideoFromFilePicker(
                        result.$1[i], result.$2[i], result.$3[i]);
                  }
                });
              },
              label: const Text("From File Explorer"),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () => _loadVideoFromDrive(context),
              label: const Text("From Google Drive"),
            ),
          ],
        ),
      ],
    );
  }
}
