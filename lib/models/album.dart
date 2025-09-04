import 'package:cloud_firestore/cloud_firestore.dart';

import 'interface/has_title_and_image.dart';

class Album implements HasTitleAndImage{
  final String id;
  final String title;
  final String artistId;
  final String coverUrl;
  final Timestamp? releaseDate;
  final String type;

  Album({
    required this.id,
    required this.title,
    required this.artistId,
    required this.type,
    required this.coverUrl,
    this.releaseDate
  });
  @override
  String get displayTitle => title;

  @override
  String get displayImageUrl => coverUrl;

  factory Album.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Album(
      id: doc.id,
      title: data['title'] ?? 'No title',
      artistId: data['artistId'] ?? '',
      coverUrl: data['coverUrl'] ?? '',
      releaseDate: data['releaseDate'],
      type: data['type'],
    );
  }
}
