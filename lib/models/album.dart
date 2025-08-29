class Album {
  final String id;
  final String title;
  final String coverUrl;

  Album({required this.id, required this.title, required this.coverUrl});

  factory Album.fromFirestore(Map<String, dynamic> data, String id) {
    return Album(
      id: id,
      title: data['title'] ?? 'No title',
      coverUrl: data['coverUrl'] ?? '',
    );
  }
}
