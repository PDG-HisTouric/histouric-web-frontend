import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../../../domain/entities/entities.dart';
import '../../js_bridge/js_bridge.dart';
import '../image/image.dart';

class ImageEntry extends StatefulWidget {
  const ImageEntry({super.key});

  @override
  State<ImageEntry> createState() => _ImageEntryState();
}

class _ImageEntryState extends State<ImageEntry> {
  String minute = '';
  bool imageChosen = false;
  List<Uint8List> images = [];
  List<String> imagesNames = [];
  List<String> imagesExtensions = [];
  bool isImageFromFilePicker = false;
  List<HistouricImageInfo> imagesInfo = [];
  AbstractFilePicker filePicker = FilePickerImpl();

  void _loadImagesFromDrive() async {
    GooglePicker.callFilePicker(
      apiKey: Environment.pickerApiKey,
      appId: Environment.pickerApiAppId,
      mediaType: MediaType.image,
    );
    GooglePicker.waitUntilThePickerIsOpen().then((value) {
      GooglePicker.waitUntilThePickerIsClosed().then((value) {
        if (!GooglePicker.callGetIsThereAnError()) {
          final selectedImagesInfo = GooglePicker.getInfoOfSelectedImages();
          for (var imageInfo in selectedImagesInfo) {
            setState(() {
              imageChosen = true;
              imagesInfo.add(imageInfo);
              isImageFromFilePicker = false;
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.35;

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
                  color: imageChosen ? Colors.transparent : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: !imageChosen
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: _loadImagesFromDrive,
                                child: const Text('Desde Google Drive'),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () async {
                                  final result =
                                      await filePicker.selectImages();
                                  setState(() {
                                    images = result.$1;
                                    imagesExtensions = result.$2;
                                    imagesNames = result.$3;
                                    isImageFromFilePicker = true;

                                    if (images.isNotEmpty) imageChosen = true;
                                  });
                                },
                                child:
                                    const Text('Desde explorador de archivos'),
                              ),
                            ],
                          )
                        : (isImageFromFilePicker
                            ? Center(
                                child: HtmlImageFromUint8List(
                                  uint8List: images[0],
                                  extension: imagesExtensions[0],
                                ),
                              )
                            : RoundedHtmlImage(
                                imageId: imagesInfo[0].id,
                                isFromDrive: true,
                              )),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: SizedBox(
                  width: 150,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Minuto del audio",
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      minute = value;
                    },
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  //_removeImageEntry(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
