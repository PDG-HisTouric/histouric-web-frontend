import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';

class TextSegment extends StatelessWidget {
  final String id;

  const TextSegment({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    TextSegmentState textSegmentState =
        context.watch<HistoryBloc>().getTextSegmentStateById(id);
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
                    controller: textSegmentState.textController,
                    decoration: const InputDecoration(
                      labelText: "Text",
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    onChanged: (value) => context
                        .read<HistoryBloc>()
                        .changeTextOfTextSegmentState(id, value),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: textSegmentState.minuteController,
                  decoration: const InputDecoration(labelText: "Minute"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => context
                      .read<HistoryBloc>()
                      .changeMinuteOfTextSegmentState(id, value),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () =>
                    context.read<HistoryBloc>().removeTextSegment(id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
