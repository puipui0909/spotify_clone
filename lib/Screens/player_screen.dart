import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class PlayerScreen extends StatefulWidget {
  final String title;
  final String artistId;
  final String coverUrl;
  final String audioUrl;

  const PlayerScreen({
    super.key,
    required this.title,
    required this.artistId,
    required this.coverUrl,
    required this.audioUrl,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.setUrl(widget.audioUrl); // phát nhạc từ Firestore
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  /// Gộp dữ liệu position + buffered + duration cho Slider
  Stream<PositionData> get _positionDataStream =>
      rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
            (position, buffered, duration) =>
            PositionData(position, buffered, duration ?? Duration.zero),
      );
  /// Lấy artist name 
  Future<String> _fetchArtistName(String artistId) async{
    final doc = 
        await FirebaseFirestore.instance.collection('artist').doc(artistId).get();
    if (doc.exists) {
      return doc['name'] ?? 'Unknown Artist';
    }
    return 'Unknown Artist';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {Navigator.pop(context); },
            icon: const Icon(Icons.keyboard_arrow_down),
        ),
        backgroundColor: Colors.transparent,
        title: const Text("Now Playing"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Ảnh cover
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.coverUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),

            /// Tên bài hát + nghệ sĩ
            Text(
              widget.title,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.artistId,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            /// Thanh progress + Slider
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return Column(
                  children: [
                    Slider(
                      activeColor: Colors.green,
                      inactiveColor: Colors.grey,
                      min: 0.0,
                      max: positionData?.duration.inMilliseconds.toDouble() ?? 1.0,
                      value: positionData?.position.inMilliseconds.toDouble() ?? 0.0,
                      onChanged: (value) {
                        _player.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(positionData?.position ?? Duration.zero),
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          _formatDuration(positionData?.duration ?? Duration.zero),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            /// Nút điều khiển (Previous, Play/Pause, Next)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 36),
                  onPressed: () {
                    // TODO: xử lý Previous
                  },
                ),
                StreamBuilder<PlayerState>(
                  stream: _player.playerStateStream,
                  builder: (context, snapshot) {
                    final playing = snapshot.data?.playing ?? false;
                    if (playing) {
                      return IconButton(
                        icon: const Icon(Icons.pause_circle_filled, size: 64),
                        onPressed: () => _player.pause(),
                      );
                    } else {
                      return IconButton(
                        icon: const Icon(Icons.play_circle_fill, size: 64),
                        onPressed: () => _player.play(),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 36),
                  onPressed: () {
                    // TODO: xử lý Next
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// format thời gian mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}

/// Class gom dữ liệu cho slider
class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}