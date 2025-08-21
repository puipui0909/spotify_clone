import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArtistScreen extends StatelessWidget {
  final String artistId;
  const ArtistScreen({super.key, required this.artistId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
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

        final artist = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    var top = constraints.biggest.height;
                    return FlexibleSpaceBar(
                      title: top <= kToolbarHeight + 50
                          ? Text(
                        artist['name'] ?? "No name",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : null,
                      background: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                            child: Image.network(
                              artist['avatar'] ?? "",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.account_circle,
                                      size: 120,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                          if (top > kToolbarHeight + 50)
                            Positioned(
                              left: 16,
                              bottom: 16,
                              child: Text(
                                artist['name'] ?? "No name",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 37,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 8,
                                      color: Colors.black54,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

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
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('songs').where('artistId', isEqualTo: artistId).snapshots(),
                          builder: (context, songSnapShot){
                            if(songSnapShot.connectionState == ConnectionState.waiting){
                              return const Center(child: CircularProgressIndicator(),);
                            }
                            if(!songSnapShot.hasData || songSnapShot.data!.docs.isEmpty){
                              return const Text('Chưa có bài hát nào');
                            }
                            final songs = songSnapShot.data!.docs;

                            return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: songs.length,
                                  itemBuilder: (context, index){
                                    final song = songs[index].data() as Map<String, dynamic>;
                                    return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            song['coverUrl'] ?? '',
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  color: Colors.grey[300],
                                                  child: const Icon(Icons.music_note),
                                                ),
                                          ),
                                        ),
                                        title: Text(song['title'] ?? 'No title', style: TextStyle(fontWeight: FontWeight.bold),),
                                        onTap: (){
                                          //TODO: open player
                                        },
                                    );
                                  }
                            );
                          },
                        ),
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
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('album').where('artistId', isEqualTo: artistId).snapshots(),
                        builder: (context, songSnapShot){
                          if(songSnapShot.connectionState == ConnectionState.waiting){
                            return const Center(child: CircularProgressIndicator(),);
                          }
                          if(!songSnapShot.hasData || songSnapShot.data!.docs.isEmpty){
                            return const Text('Chưa có album nào');
                          }
                          final songs = songSnapShot.data!.docs;

                          return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: songs.length,
                              itemBuilder: (context, index){
                                final song = songs[index].data() as Map<String, dynamic>;
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      song['coverUrl'] ?? '',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(
                                            width: 50,
                                            height: 50,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.music_note),
                                          ),
                                    ),
                                  ),
                                  title: Text(song['title'] ?? 'No title', style: TextStyle(fontWeight: FontWeight.bold),),
                                  onTap: (){
                                    //TODO: open player
                                  },
                                );
                              }
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
