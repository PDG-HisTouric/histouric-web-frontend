import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../blocs/blocs.dart';
import '../../js_bridge/js_bridge.dart';
import '../audio/audio.dart';

class LoadAudio extends StatelessWidget {
  LoadAudio({super.key});
  final AbstractFilePicker filePicker = FilePickerImpl();

  void _loadAudioFromDrive(BuildContext context) {
    GooglePicker.callFilePicker(
      apiKey: Environment.pickerApiKey,
      appId: Environment.pickerApiAppId,
      mediaType: MediaType.audio,
    );
    GooglePicker.waitUntilThePickerIsOpen().then((value) {
      GooglePicker.waitUntilThePickerIsClosed().then((value) {
        if (!GooglePicker.callGetIsThereAnError()) {
          final src = GooglePicker.callGetSelectedAudioUrl();
          context.read<HistoryBloc>().changeAudioState(
                isAudioFromFilePicker: false,
                src: src,
              );
        }
      });
    });
  }

  void _loadAudioFromFilePicker(BuildContext context) {
    filePicker.selectAudio().then((result) {
      final audio = result.$1;
      if (audio != null) {
        context.read<HistoryBloc>().changeAudioState(
              isAudioFromFilePicker: true,
              audio: result.$1,
              audioExtension: result.$2,
              audioName: result.$3,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioState = context
        .select((HistoryBloc historyBloc) => historyBloc.state.audioState);
    return Column(
      children: [
        if (!audioState.isAudioFromFilePicker)
          HtmlAudioContainer(
            src: audioState.src,
            width: 400,
            onChangeAudioTime: (currentTime) {},
          ),
        if (audioState.isAudioFromFilePicker)
          HtmlAudioFromUint8List(
            uint8List: audioState.audio!,
            extension: audioState.audioExtension!,
            width: 400,
            onChangeAudioTime: (currentTime) {},
          ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () => _loadAudioFromFilePicker(context),
              label: const Text("Desde el explorador de archivos"),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () {
                _loadAudioFromDrive(context);
              },
              label: const Text("Desde Google Drive"),
            ),
          ],
        ),
      ],
    );
  }
}
