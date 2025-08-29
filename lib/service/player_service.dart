import 'package:just_audio/just_audio.dart';

class AudioPlayerHandler {
  static final _player = AudioPlayer();

  static AudioPlayer get player => _player;

  static Future<void> playSong(String url) async {
    try {
      await _player.setUrl(url); // url của bài nhạc (firestore, local, hoặc api)
      await _player.play();
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  static void pause() {
    _player.pause();
  }

  static void stop() {
    _player.stop();
  }
}
