import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_clone/models/artist.dart';
import '../models/song.dart';
import '../Screens/player_screen.dart';
import '../Screens/artist_screen.dart';

enum MediaType { song, artist }

class MediaItem extends StatelessWidget {
  final MediaType type;
  final Song? song;
  final Artist? artist;

  final double width;
  final double height;

  const MediaItem.song({
    super.key,
    required this.song,
    this.width = 147,
    this.height = 193,
  })  : type = MediaType.song,
        artist = null;

  const MediaItem.artist({
    super.key,
    required this.artist,
    this.width = 147,
    this.height = 147,
  })  : type = MediaType.artist,
        song = null;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case MediaType.song:
        return _buildSongItem(context);
      case MediaType.artist:
        return _buildArtistItem(context);
    }
  }

  /// ================= SONG ITEM =================
  Widget _buildSongItem(BuildContext context) {
    final songData = song!;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlayerScreen(
              title: songData.title,
              artistId: songData.artistId,
              coverUrl: songData.coverUrl ?? '',
              audioUrl: songData.audioUrl ?? '',
            ),
          ),
        );
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                songData.coverUrl ?? "",
                width: width,
                height: height,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: width,
                  height: height,
                  color: Colors.purple[300],
                  child: const Icon(Icons.music_note, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              songData.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            // Artist name
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('artist')
                  .doc(songData.artistId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Đang tải...");
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Text("Unknown Artist");
                }
                final artistData =
                snapshot.data!.data() as Map<String, dynamic>;
                return Text(
                  artistData['name'] ?? "Unknown Artist",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  /// ================= ARTIST ITEM =================
  Widget _buildArtistItem(BuildContext context) {
    final artistData = artist!;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArtistScreen(artistId: artistData.id!),
          ),
        );
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          children: [
            ClipOval(
              child: Image.network(
                artistData.avatar,
                width: width,
                height: width,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: width,
                  height: width,
                  color: Colors.grey[300],
                  child: const Icon(Icons.account_circle, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              artistData.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
