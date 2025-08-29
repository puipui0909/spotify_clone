import 'package:cloud_firestore/cloud_firestore.dart';

class Artist {
  final String id;
  final String name;
  final String avatar;
  final num follower;

  Artist({
    required this.id,
    required this.name,
    required this.avatar,
    required this.follower});

  //Tạo objcet từ Firestore document
  factory Artist.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Artist(
      id: doc.id,
      name: data['name'] ?? 'No name',
      avatar: data['avatar'] ?? '',
      follower: data['follower'] ?? '0',
    );
  }
}
