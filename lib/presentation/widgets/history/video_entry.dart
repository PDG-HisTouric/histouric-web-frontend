import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../video/video.dart';

class VideoEntry extends StatelessWidget {
  final String id;
  final bool isVideoFromFilePicker;
  final Uint8List? video;
  final String? extension;
  final String? name;
  final String? url;
  final double? width;
  final double? height;
  const VideoEntry({
    super.key,
    required this.isVideoFromFilePicker,
    this.video,
    this.extension,
    this.name,
    this.url,
    this.width,
    this.height,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            isVideoFromFilePicker
                ? HtmlVideoFromUint8List(
                    uint8List: video!, extension: extension!)
                : HtmlVideoContainer(url: url!),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<HistoryBloc>().removeVideoEntry(id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
