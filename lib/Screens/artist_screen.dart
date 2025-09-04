import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_clone/Screens/album_screen.dart';
import 'package:spotify_clone/Screens/player_screen.dart';
import 'package:spotify_clone/models/album.dart';
import 'package:spotify_clone/widgets/cover_appbar.dart';
import 'package:spotify_clone/widgets/list.dart';

import '../models/artist.dart';
import '../models/song.dart';

class ArtistScreen extends StatelessWidget {
  final String artistId;
  const ArtistScreen({super.key, required this.artistId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('artist')
          .doc(artistId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text("Artist không tồn tại")),
          );
        }

        final artist = Artist.fromDoc(snapshot.data!);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              CoverAppbar(item: artist),
              // Nội dung bên dưới
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 17),
                      const Text(
                        "Bài hát nổi bật",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance.collection('songs').where('artistId', isEqualTo: artistId).snapshots(),
                          builder: (context, songSnapShot) {
                            if (songSnapShot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),);
                            }
                            if (!songSnapShot.hasData ||
                                songSnapShot.data!.docs.isEmpty) {
                              return const Text('Chưa có bài hát nào');
                            }
                            final songs = songSnapShot.data!.docs.map((doc) =>
                                Song.fromDoc(doc)).toList();

                            return ListWidget(
                              items: songs,
                              getTitle: (song) => song.title,
                              getCoverUrl: (song) => song.coverUrl,
                              onTap: (context, song) {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => PlayerScreen(song: song)),);
                              },
                            );
                          }
                        )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 17),
                      const Text(
                        "Album",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance.collection('album').where('artistId', isEqualTo: artistId).snapshots(),
                        builder: (context, albumSnapShot){
                          if(albumSnapShot.connectionState == ConnectionState.waiting){
                            return const Center(child: CircularProgressIndicator(),);
                          }
                          if(!albumSnapShot.hasData || albumSnapShot.data!.docs.isEmpty){
                            return const Text('Chưa có album nào');
                          }
                          final albums = albumSnapShot.data!.docs.map((doc) => Album.fromDoc(doc)).toList();
                          return ListWidget(
                              items: albums,
                              getTitle: (album) => album.title,
                              getCoverUrl: (album) => album.coverUrl,
                              onTap: (context, album) {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => AlbumScreen(albumId: album.id)));
                              },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
