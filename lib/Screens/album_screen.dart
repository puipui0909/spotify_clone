import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_clone/Screens/player_screen.dart';
import 'package:spotify_clone/widgets/list.dart';

import '../models/album.dart';
import '../models/song.dart';
import '../widgets/cover_appbar.dart';


class AlbumScreen extends StatelessWidget{
  final String albumId;
  const AlbumScreen({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('album').doc(albumId).snapshots(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text("Album không tô tại")),
          );
        }

        final albums = Album.fromDoc(snapshot.data!);
        return Scaffold(
            body: CustomScrollView(
                slivers: [
                  CoverAppbar(item: albums),
            // Nội dung bên dưới
                  SliverToBoxAdapter(
                    child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 17),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance.collection('songs').where('albumId', isEqualTo: albumId).snapshots(),
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
                                  builder: (_) => PlayerScreen(song: song)       ),
                              );
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