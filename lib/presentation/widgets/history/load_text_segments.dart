import 'package:flutter/material.dart';

import 'text_segment.dart';

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
