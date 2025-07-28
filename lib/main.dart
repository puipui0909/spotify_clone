import 'package:flutter/material.dart';
import 'Screens/library.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black12,
          foregroundColor: Colors.white,
          elevation: 2
        )
      ),
      home: const LibraryScreen()
    );
    // TODO: implement build
    throw UnimplementedError();
  }

}
