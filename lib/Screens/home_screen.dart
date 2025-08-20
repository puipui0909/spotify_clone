import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: (){

                  },
                  icon: Icon(Icons.search),),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.asset(
                    'assets/images/loading.png',
                    height: 33,
                    width: 108,
                  ),
                ),
              )
            ],
          ),
        ),
        body: Column(
          children: [
            const TabBar(
                tabs: [
                  Tab(text: 'News',),
                  Tab(text: 'Artist',),
                  Tab(text: 'Podcast',),
                ]
            ),
            Expanded(
                child: TabBarView(
                    children: [
                      NewsTab(),
                      ArtistTab(),
                      PodcastTab(),
                    ]
                )
            ),

          ],
        ),
      ),
    );
  }
}

class NewsTab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('songs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Lỗi khi tải dữ liệu"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Không có bài hát nào"));
          }

          final songs = snapshot.data!.docs;
          // tạo list nằm ngang
          return SizedBox(
            height: 242,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: songs.length,
                itemBuilder: (context, index){
                  final song = songs[index].data() as Map<String, dynamic>;

                  return Container(
                    width: 147,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //CoverUrl
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            song['coverUrl'] ?? "",
                            width: 147,
                            height: 193,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 147,
                                height: 193,
                                color: Colors.purple[300],
                                child: const Icon(Icons.music_note, size: 50),
                              ),
                          ),
                        ),
                        const SizedBox(height: 3,),
                        Text(
                          song['title'] ?? 'No Title',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('artist').doc(song['artistId']).get(),
                          builder: (context,artistSnapshot){
                            if(artistSnapshot.connectionState == ConnectionState.waiting){
                              return const Text('Đang tải...');
                            }
                            if(!artistSnapshot.hasData || !artistSnapshot.data!.exists){
                              return const Text('Unknow Artist');
                            }
                            final artistData = artistSnapshot.data!.data()
                              as Map<String, dynamic>;
                            return Text(
                              artistData['name'] ?? "Unknow Artist",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                              )
                            );
                          }
                        ),
                      ],
                    ),
                  );
                }
            ),
          );
        },
      );
  }
}

class ArtistTab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('artist').snapshots(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),);
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Lỗi khi tải dữ liệu'),);
        }
        if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
          return const Center(child: Text('Không có artist nào'));
        }
        final artists = snapshot.data!.docs;

        return SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: artists.length,
            itemBuilder: (context, index){
              final artist = artists[index].data() as Map<String, dynamic>;

              return Container(
                width: 150,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.network(
                        artist['avatar'],
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                          Container(
                            width: 150,
                            height: 150,
                            color: Colors.grey[300],
                            child: const Icon(Icons.account_circle),
                          ),
                      )
                    ),
                    SizedBox(height: 6,),
                    Text(
                      artist['name'] ?? "No Title",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              );
            }
          )
        );
      }
    );
  }
}

class PodcastTab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('podcasts').snapshots(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),);
        }
        if (snapshot.hasError){
          return const Center(child: Text('Lỗi khi tải dữ liệu'),);
        }
        if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
          return const Center (child:  Text('không có nội dung nào'),);
        }
        final podcasts = snapshot.data!.docs;

        return SizedBox(
          height: 220,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: podcasts.length,
              itemBuilder: (context, index){
                final podcast = podcasts[index].data() as Map<String, dynamic>;

                return Container(
                  width: 220,
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      ],
                  )
                );
              }
          ),
        );
      },
    );
  }
}