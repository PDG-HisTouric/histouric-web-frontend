import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';

class TextSegment extends StatelessWidget {
  final String id;

  const TextSegment({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final textSegments = context.select(
        (HistoryBloc historyBloc) => historyBloc.state.textSegmentStates);
    final textSegmentState =
        textSegments.firstWhere((element) => element.id == id);
    final colors = Theme.of(context).colorScheme;
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
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: textSegmentState.textController,
                    decoration: InputDecoration(
                      labelText: "Texto",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: colors.primary),
                      ),
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
                  decoration:
                      const InputDecoration(labelText: "Minuto del audio"),
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
