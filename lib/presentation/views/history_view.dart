import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:histouric_web/infrastructure/infrastructure.dart';

import '../../domain/domain.dart';
import '../widgets/widgets.dart';

class HistoryView extends StatefulWidget {
  final String historyId;

  const HistoryView({super.key, required this.historyId});

  @override
  State<HistoryView> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryView> {
  bool _isPlaying = false;
  late final AudioPlayer _audioPlayer;
  late final AssetSource _assetSource;

  Duration _duration = const Duration();
  Duration _position = const Duration();

  History? history;

  HistoryText? currentHistoryText;

  @override
  void initState() {
    super.initState();
    // ref.read(historyInfoProvider.notifier).loadHistory(widget.historyId);
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initAudioPlayer() async {
    _audioPlayer = AudioPlayer();
    _assetSource = AssetSource('audios/13PorObraYGraciaDeMicaela.mp3');
    _audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        _duration = event;
      });
    });
    _audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        _position = event;
        updateCurrentTextSegment(event);
      });
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _position = _duration;
        _isPlaying = false;
      });
    });
  }

  Future<void> _play() async {
    await _audioPlayer.play(_assetSource);
    setState(() {
      _isPlaying = true;
    });
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  void updateCurrentTextSegment(Duration position) {
    HistoryText? newHistoryText;

    for (var historyText in history!.texts) {
      if (position >= Duration(seconds: historyText.startTime)) {
        newHistoryText = historyText;
      } else {
        break;
      }
    }

    if (newHistoryText != currentHistoryText) {
      setState(() {
        currentHistoryText = newHistoryText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    HistoryRepository historyRepository = HistoryRepositoryImpl(
        historyDatasource: HistoryDatasourceImpl(
            firebaseStorageRepository: FirebaseStorageRepositoryImpl(
                firebaseStorageDataSource: FirebaseStorageDatasourceImpl())));

    historyRepository
        .getHistoryById(widget.historyId)
        .then((value) => setState(() {
              history = value;
            }));

    if (history == null) {
      return const SafeArea(
        child: Scaffold(
          body: Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            history!.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFE7C18B),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE7C18B), Color(0xFFA1887F)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: history!.images?.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: RoundedHtmlImage(
                              imageId: history!.images![index].imageUri,
                              width: MediaQuery.sizeOf(context).width,
                              height: 200,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeIn(
                    duration: const Duration(milliseconds: 700),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: NeuBox(
                        child: Text(
                          currentHistoryText?.content ??
                              'Presiona play para escuchar la historia',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              width: MediaQuery.sizeOf(context).width,
              bottom: 0,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(231, 193, 139, 1.0),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Escucha la historia',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_position.inMinutes}:${_position.inSeconds.remainder(60)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_duration.inMinutes}:${_duration.inSeconds.remainder(60)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Slider(
                      value: _position.inSeconds.toDouble(),
                      min: 0,
                      max: _duration.inSeconds.toDouble(),
                      onChanged: (value) async {
                        await _audioPlayer
                            .seek(Duration(seconds: value.toInt()));
                        setState(() {});
                      },
                      inactiveColor: Colors.black.withOpacity(0.2),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              _audioPlayer.seek(
                                _position - const Duration(seconds: 10),
                              );
                              setState(() {});
                            },
                            icon: const Icon(Icons.replay_10_outlined),
                          ),
                          IconButton(
                            onPressed: () {
                              _isPlaying ? _pause() : _play();
                            },
                            icon: Icon(
                              _isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _audioPlayer.seek(
                                _position + const Duration(seconds: 10),
                              );
                              setState(() {});
                            },
                            icon: const Icon(Icons.forward_10_outlined),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
