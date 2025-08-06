import 'package:flutter/material.dart';
import 'package:spotify_clone/Screens/choose_theme_screen.dart';
import 'package:spotify_clone/Screens/get_started_screen.dart';
import 'Screens/library.dart';
import 'theme/theme.dart';
import 'theme/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'Screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: const MyApp()
      ),
  );
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'Spotify',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeNotifier.themeMode,
      home: const RegisterScreen()
      //home: LoadingScreen(),
    );
  }

}
