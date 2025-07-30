import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget{
  const LibraryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       toolbarHeight: 75,
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text('D', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),),
            ),
        ),
        title: Text('Thư viện', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              onPressed: (){
                //Tìm kiếm
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: (){
                //Thêm
              },
              icon: const Icon(Icons.add))
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: Row(
              children: [
                SizedBox(width: 10,),
                TextButton(
                    onPressed: (){
                      //phân nhóm
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Danh sách phát',style: TextStyle(color: Colors.white)),

                ),
                SizedBox(width: 3,),
                TextButton(
                    onPressed: (){
                      //phân nhóm
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Podcast',style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 3,),
                TextButton(
                    onPressed: (){
                      //phân nhóm
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Nghệ sĩ',style: TextStyle(color: Colors.white)),

                ),
              ],
            ),
     ),
     ),
      body: Column(
        children: [
          Card(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 7,),
                  Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bài hát ưa thích', style: TextStyle(color: Colors.white, fontSize: 20), ),
                          Text('Danh sách phát - 69 bài', style: TextStyle(color: Colors.grey, fontSize: 14), ),
                        ],
                      )
                  ),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 7,),
                  Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tập của bạn', style: TextStyle(color: Colors.white, fontSize: 20), ),
                          Text('Các tập đã lưu và tải xuống', style: TextStyle(color: Colors.grey, fontSize: 14), ),
                        ],
                      )
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          //currentIndex: _selectedIndex,
          items:const[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
            BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Thư viện'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Thêm'),
          ]
      ),
    );
  }

}
