import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
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
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),),
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
          bottom: const TabBar(
              tabs: [
                Tab(text: 'News',),
                Tab(text: 'Artist',),
                Tab(text: 'Podcasts',)
              ]
          ),
        ),
        body: const TabBarView(
            children: [
              NewsTab(),
              ArtistTab(),
              PodcastsTab(),
            ]),
      ),
    );
  }
}

class NewsTab extends StatelessWidget {
  const NewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 20,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          title: Text('📰 News item ${index + 1}'),
        ),
      ),
    );
  }
}

class VideoTab extends StatelessWidget {
  const VideoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 15,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          title: Text('🎥 Video item ${index + 1}'),
        ),
      ),
    );
  }
}

class ArtistTab extends StatelessWidget {
  const ArtistTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 12,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          title: Text('🎤 Artist ${index + 1}'),
        ),
      ),
    );
  }
}

class PodcastsTab extends StatelessWidget {
  const PodcastsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 10,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          title: Text('🎧 Podcast ${index + 1}'),
        ),
      ),
    );
  }
}
