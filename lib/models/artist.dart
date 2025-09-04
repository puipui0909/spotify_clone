import 'package:cloud_firestore/cloud_firestore.dart';

import 'interface/has_title_and_image.dart';

class Artist implements HasTitleAndImage{
  final String id;
  final String name;
  final String avatar;
  final num follower;

  Artist({
    required this.id,
    required this.name,
    required this.avatar,
    required this.follower});
  @override
  String get displayTitle => name;

  @override
  String get displayImageUrl => avatar;

  //Tạo objcet từ Firestore document
  factory Artist.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Artist(
      id: doc.id,
      name: data['name'] ?? 'No name',
      avatar: data['avatar'] ?? '',
      follower: data['follower'] ?? 0,
    );
  }
}
