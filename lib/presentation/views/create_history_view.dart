import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../config/config.dart';
import '../../domain/domain.dart';
import '../js_bridge/js_bridge.dart';
import '../widgets/widgets.dart';

class CreateHistoryView extends StatefulWidget {
  const CreateHistoryView({super.key});

  @override
  State<CreateHistoryView> createState() => _CreateHistoryViewState();
}

class _CreateHistoryViewState extends State<CreateHistoryView> {
  int _currentStep = 0;

  final List<Step> _steps = [
    const Step(
      title: Text("Cargar Audio"),
      content: _LoadAudio(),
    ),
    const Step(
      title: Text("Cargar Imágenes"),
      content: LoadImages(),
    ),
    const Step(
      title: Text("Cargar Segmentos de Texto"),
      content: LoadTextSegments(),
    ),
    const Step(
      title: Text("Cargar Videos (Opcional)"),
      content: LoadVideos(),
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nueva historia",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stepper(
        steps: _steps,
        currentStep: _currentStep,
        onStepTapped: (step) {
          setState(() {
            _currentStep = step;
          });
        },
        onStepContinue: () {
          if (_currentStep < _steps.length - 1) {
            setState(() {
              _currentStep++;
            });
          }
          if (_currentStep == _steps.length - 1) {
            // Create history
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          } else {
            Navigator.pop(context);
          }
        },
        physics: const BouncingScrollPhysics(),
        type: StepperType.horizontal,
        connectorColor: MaterialStateProperty.all(Colors.blue),
        controlsBuilder: (context, controlsDetails) {
          return SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentStep == 0)
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.cancel),
                    onPressed: controlsDetails.onStepCancel,
                    label: const Text("Cancel"),
                  ),
                if (_currentStep != 0)
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: controlsDetails.onStepCancel,
                    label: const Text("Back"),
                  ),
                const SizedBox(width: 10),
                if (_currentStep != _steps.length - 1)
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: controlsDetails.onStepContinue,
                    label: const Text("Next"),
                  ),
                if (_currentStep == _steps.length - 1)
                  FilledButton.icon(
                    icon: const Icon(Icons.check),
                    onPressed: controlsDetails.onStepContinue,
                    label: const Text("Finish"),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LoadAudio extends StatefulWidget {
  const _LoadAudio();

  @override
  State<_LoadAudio> createState() => _LoadAudioState();
}

class _LoadAudioState extends State<_LoadAudio> {
  String src = '';
  String time = '';
  Uint8List? audio;
  String? audioName;
  String? audioExtension;
  String selectedAudioPath = "";
  bool isAudioFromFilePicker = false;
  AbstractFilePicker filePicker = FilePickerImpl();

  Future<void> pickAudioFromExplorer() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() {
        selectedAudioPath = result.files.single.path!;
      });
    }
  }

  void _loadAudioFromDrive() {
    GooglePicker.callFilePicker(
      apiKey: Environment.pickerApiKey,
      appId: Environment.pickerApiAppId,
      mediaType: MediaType.audio,
    );
    GooglePicker.waitUntilThePickerIsOpen().then((value) {
      GooglePicker.waitUntilThePickerIsClosed().then((value) {
        if (!GooglePicker.callGetIsThereAnError()) {
          final audioId = GooglePicker.callGetSelectedAudioId();
          setState(() {
            isAudioFromFilePicker = false;
            src = 'https://drive.google.com/uc?export=view&id=$audioId';
          });
        }
      });
    });
  }

  void _onChangeAudioTime(String currentTime) {
    setState(() {
      time = currentTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isAudioFromFilePicker)
          HtmlAudioContainer(
            src: src,
            width: 400,
            onChangeAudioTime: _onChangeAudioTime,
          ),
        if (isAudioFromFilePicker)
          HtmlAudioFromUint8List(
            uint8List: audio!,
            extension: audioExtension!,
            width: 400,
            onChangeAudioTime: _onChangeAudioTime,
          ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () {
                filePicker.selectAudio().then((result) {
                  setState(() {
                    isAudioFromFilePicker = true;
                    audio = result.$1;
                    audioExtension = result.$2;
                    audioName = result.$3;
                  });
                });
              },
              label: const Text("From File Explorer"),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: _loadAudioFromDrive,
              label: const Text("From Google Drive"),
            ),
          ],
        ),
      ],
    );
  }
}

class LoadImages extends StatefulWidget {
  const LoadImages({super.key});

  @override
  State<LoadImages> createState() => _LoadImagesState();
}

class _LoadImagesState extends State<LoadImages> {
  List<Uint8List> images = [];
  List<String> imagesNames = [];
  bool isImageFromFilePicker = false;
  List<ImageEntry> imageEntries = [];
  List<String> imagesExtensions = [];
  List<HistouricImageInfo> imagesInfo = [];
  AbstractFilePicker filePicker = FilePickerImpl();

  void _addImageEntry() {
    setState(() {
      imageEntries.add(const ImageEntry());
    });
  }

  void _removeImageEntry(int index) {
    setState(() {
      imageEntries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (int index = 0; index < imageEntries.length; index++)
            const ImageEntry(),
          const SizedBox(height: 10),
          FilledButton.icon(
            icon: const Icon(Icons.add),
            onPressed: _addImageEntry,
            label: const Text("Add Image"),
          ),
        ],
      ),
    );
  }
}

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

class LoadTextSegments extends StatefulWidget {
  const LoadTextSegments({super.key});

  @override
  State<LoadTextSegments> createState() => _LoadTextSegmentsState();
}

class _LoadTextSegmentsState extends State<LoadTextSegments> {
  List<TextSegment> textSegments = [];

  void _addTextSegmentEntry() {
    setState(() {
      textSegments.add(const TextSegment());
    });
  }

  void _removeTextSegmentEntry(int index) {
    setState(() {
      textSegments.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (int index = 0; index < textSegments.length; index++)
            const TextSegment(),
          const SizedBox(height: 10),
          FilledButton.icon(
            icon: const Icon(Icons.add),
            onPressed: _addTextSegmentEntry,
            label: const Text("Add Text Segment"),
          ),
        ],
      ),
    );
  }
}

class TextSegment extends StatefulWidget {
  const TextSegment({super.key});

  @override
  State<TextSegment> createState() => _TextSegmentState();
}

class _TextSegmentState extends State<TextSegment> {
  String text = '';
  String minute = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 10,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Text",
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    onChanged: (value) {
                      minute = value;
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Minute"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    text = value;
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  //_removeTextSegmentEntry(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
