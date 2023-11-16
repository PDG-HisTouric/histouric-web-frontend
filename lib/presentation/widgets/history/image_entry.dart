import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../../domain/entities/entities.dart';
import '../../blocs/blocs.dart';
import '../../js_bridge/js_bridge.dart';
import '../image/image.dart';

class ImageEntry extends StatelessWidget {
  final String id;

  ImageEntry({super.key, required this.id});

  final AbstractFilePicker filePicker = FilePickerImpl();

  void _loadImagesFromDrive(BuildContext context) async {
    GooglePicker.callFilePicker(
      apiKey: Environment.pickerApiKey,
      appId: Environment.pickerApiAppId,
      mediaType: MediaType.image,
    );
    GooglePicker.waitUntilThePickerIsOpen().then((value) {
      GooglePicker.waitUntilThePickerIsClosed().then((value) {
        if (!GooglePicker.callGetIsThereAnError()) {
          final selectedImagesInfo = GooglePicker.getInfoOfSelectedImages();
          List<HistouricImageInfo> imagesInfo = [
            ...context.read<HistoryBloc>().getImageEntryStateById(id).imagesInfo
          ];
          int initialSize = imagesInfo.length;
          for (var imageInfo in selectedImagesInfo) {
            imagesInfo.add(imageInfo);
          }
          int finalSize = imagesInfo.length;
          if (initialSize < finalSize) {
            context.read<HistoryBloc>().changeImageEntryState(
                  id: id,
                  imagesInfo: imagesInfo,
                  imageChosen: true,
                  isImageFromFilePicker: false,
                );
          }
        }
      });
    });
  }

  void _loadImagesFromFilePicker(BuildContext context) {
    filePicker.selectImages().then((result) {
      final images = result.$1;
      if (images.isNotEmpty) {
        context.read<HistoryBloc>().changeImageEntryState(
              id: id,
              images: images,
              imageChosen: true,
              isImageFromFilePicker: true,
              imagesExtensions: result.$2,
              imagesNames: result.$3,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.35;
    final imageEntries = context.select(
        (HistoryBloc historyBloc) => historyBloc.state.imageEntryStates);
    final imageEntryState =
        imageEntries.firstWhere((element) => element.id == id);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: cardWidth,
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  color:
                      imageEntryState.imageChosen ? Colors.transparent : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: !imageEntryState.imageChosen
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () => _loadImagesFromDrive(context),
                                child: const Text('Desde Google Drive'),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () =>
                                    _loadImagesFromFilePicker(context),
                                child:
                                    const Text('Desde explorador de archivos'),
                              ),
                            ],
                          )
                        : (imageEntryState.isImageFromFilePicker
                            ? Center(
                                child: HtmlImageFromUint8List(
                                  uint8List: imageEntryState.images[0],
                                  extension:
                                      imageEntryState.imagesExtensions[0],
                                ),
                              )
                            : RoundedHtmlImage(
                                imageId: imageEntryState.imagesInfo[0].url)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: SizedBox(
                  width: 150,
                  child: TextFormField(
                    controller: imageEntryState.minuteController,
                    decoration: const InputDecoration(
                      labelText: "Minuto del audio",
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      context
                          .read<HistoryBloc>()
                          .changeMinuteOfImageEntryState(id, value);
                    },
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  context.read<HistoryBloc>().removeImageEntryState(id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
