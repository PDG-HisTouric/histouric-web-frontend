import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../../../domain/entities/entities.dart';
import 'image_entry.dart';

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
