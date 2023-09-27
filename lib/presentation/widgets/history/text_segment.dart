import 'package:flutter/material.dart';

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
