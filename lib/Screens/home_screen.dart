import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_clone/Screens/artist_screen.dart';
import 'package:spotify_clone/Screens/player_screen.dart';
import 'package:spotify_clone/models/artist.dart';
import 'package:spotify_clone/widgets/custom_appbar.dart';
import 'package:spotify_clone/widgets/items.dart';
import 'package:spotify_clone/models/song.dart';
import 'package:spotify_clone/models/artist.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(
          action: IconButton(
              onPressed: (){
                // showSearch(
                //     context: context,
                //     delegate: MySearchDelegate(),)
              },
              icon: Icon(Icons.search)),
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
        bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.grey[300],
            selectedItemColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            iconSize: 37,
            //currentIndex: _selectedIndex,
            items:const[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.my_library_books), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
            ]
        ),
      ),
    );
  }
}

class NewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('songs')
          .orderBy('createAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final songs =
        snapshot.data!.docs.map((doc) => Song.fromDoc(doc)).toList();

        return SizedBox(
          height: 242,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: songs.length,
            itemBuilder: (context, index) =>
                MediaItem.song(song: songs[index]), // 🔹 Dùng chung
          ),
        );
      },
    );
  }
}


class ArtistTab extends StatelessWidget{
  //
  @override
  Widget build(BuildContext context){
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('artist').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return const Center(child: CircularProgressIndicator());
        }
        final artists = snapshot.data!.docs.map((doc) => Artist.fromDoc(doc)).toList();
        return SizedBox(
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: artists.length,
              itemBuilder: (context, index) => MediaItem.artist(artist: artists[index],)
          ),
        );
      },
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