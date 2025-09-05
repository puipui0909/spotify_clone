import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_clone/Screens/album_screen.dart';
import 'package:spotify_clone/models/song.dart';
import 'package:spotify_clone/models/album.dart';
import 'package:spotify_clone/models/artist.dart';
import 'package:spotify_clone/Screens/player_screen.dart';
import 'package:spotify_clone/Screens/artist_screen.dart';


class MySearchDelegate extends SearchDelegate {
  List<Song> _allSongs = [];
  List<Artist> _allArtists = [];
  List<Album> _allAlbums = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _allPodcasts = [];
  bool _isLoaded = false;

  /// Load dữ liệu một lần duy nhất
  Future<void> _loadAllData() async {
    final songSnap = await FirebaseFirestore.instance.collection('songs').get();
    final artistSnap = await FirebaseFirestore.instance.collection('artist').get();
    final podcastSnap = await FirebaseFirestore.instance.collection('podcasts').get();
    final albumSnap = await FirebaseFirestore.instance.collection('album').get();

    _allSongs = songSnap.docs.map((doc) => Song.fromDoc(doc)).toList();
    _allAlbums = albumSnap.docs.map((doc) => Album.fromDoc(doc)).toList();
    _allArtists = artistSnap.docs.map((doc) => Artist.fromDoc(doc)).toList();
    _allPodcasts = podcastSnap.docs;
    _isLoaded = true;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults(context);

  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text("Nhập để tìm kiếm..."));
    }

    return FutureBuilder(
      future: _isLoaded ? Future.value() : _loadAllData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final lowerQuery = query.toLowerCase();

        final songs = _allSongs.where((s) => s.title.toLowerCase().contains(lowerQuery)).toList();
        final albums = _allAlbums.where((al) => al.title.toLowerCase().contains(lowerQuery)).toList();
        final artists = _allArtists.where((a) => a.name.toLowerCase().contains(lowerQuery)).toList();
        final podcasts = _allPodcasts.where((p) {
          final title = (p.data()['title'] ?? '').toString().toLowerCase();
          return title.contains(lowerQuery);
        }).toList();

        if (songs.isEmpty && artists.isEmpty && podcasts.isEmpty) {
          return const Center(child: Text("Không tìm thấy kết quả"));
        }

        return ListView(
          children: [
            if (songs.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Bài hát",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ...songs.map((s) => ListTile(
                leading: const Icon(Icons.music_note),
                title: Text(s.title),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayerScreen(song: s),
                    ),
                  );
                },
              )),
            ],
            if (artists.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Nghệ sĩ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ...artists.map((a) => ListTile(
                leading: const Icon(Icons.person),
                title: Text(a.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArtistScreen(artistId: a.id),
                    ),
                  );
                },
              )),
            ],
            if (albums.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Album",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ...albums.map((al) => ListTile(
                leading: const Icon(Icons.album),
                title: Text(al.title),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AlbumScreen(albumId: al.id),
                    ),
                  );
                },
              )),
            ],
            if (podcasts.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Podcast",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ...podcasts.map((p) {
                final data = p.data();
                return ListTile(
                  leading: const Icon(Icons.podcasts),
                  title: Text(data['title'] ?? 'No title'),
                  onTap: () {
                    // 👉 mở PodcastScreen nếu bạn có
                  },
                );
              }),
            ],
          ],
        );
      },
    );
  }
}
