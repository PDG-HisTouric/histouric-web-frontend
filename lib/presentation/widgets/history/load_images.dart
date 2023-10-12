import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../../domain/entities/entities.dart';
import '../../blocs/blocs.dart';
import 'image_entry.dart';

class LoadImages extends StatelessWidget {
  LoadImages({super.key});

  // List<ImageEntry> imageEntries = [];
  final AbstractFilePicker filePicker = FilePickerImpl();

  void _addImageEntry(BuildContext context) {
    context.read<HistoryBloc>().addImageEntryState();
  }

  @override
  Widget build(BuildContext context) {
    List<ImageEntryState> imageEntries =
        context.watch<HistoryBloc>().state.imageEntryStates;

    return SingleChildScrollView(
      child: Column(
        children: [
          for (int index = 0; index < imageEntries.length; index++)
            ImageEntry(id: imageEntries[index].id),
          const SizedBox(height: 10),
          FilledButton.icon(
            icon: const Icon(Icons.add),
            onPressed: () => _addImageEntry(context),
            label: const Text("Add Image"),
          ),
        ],
      ),
    );
  }
}