import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String id;
  final String title;
  final String artistId;
  final String? coverUrl;
  final String? audioUrl;
  final Timestamp? createAt;  // Firestore lưu DateTime dạng Timestamp
  final String? albumId;

  Song({
    required this.id,
    required this.title,
    required this.artistId,
    this.coverUrl,
    this.audioUrl,
    this.createAt,
    this.albumId,
  });

  // Tạo object từ Firestore document
  factory Song.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Song(
      id: doc.id,
      title: data['title'] ?? '',
      artistId: data['artistId'] ?? '',
      coverUrl: data['coverUrl'],
      audioUrl: data['audioUrl'],
      createAt: data['createAt'],
      albumId: data['albumId'],
    );
  }
}
