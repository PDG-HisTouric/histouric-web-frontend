import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';

import 'text_segment.dart';

class LoadTextSegments extends StatelessWidget {
  const LoadTextSegments({super.key});

  @override
  Widget build(BuildContext context) {
    List<TextSegmentState> textSegments =
        context.watch<HistoryBloc>().state.textSegmentStates;
    return SingleChildScrollView(
      child: Column(
        children: [
          for (int index = 0; index < textSegments.length; index++)
            TextSegment(id: textSegments[index].id),
          const SizedBox(height: 10),
          FilledButton.icon(
            icon: const Icon(Icons.add),
            onPressed: context.read<HistoryBloc>().addTextSegment,
            label: const Text("Add Text Segment"),
          ),
        ],
      ),
    );
  }
}
