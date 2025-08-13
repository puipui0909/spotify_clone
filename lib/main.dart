import 'package:flutter/material.dart';
import 'package:spotify_clone/Screens/get_started_screen.dart';
import 'theme/theme.dart';
import 'theme/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/signin_screen.dart';
import 'Screens/register_screen.dart';
import 'Screens/home_screen.dart';





void main() async {
  //connect to firebase
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
        initialRoute: '/signin',
        routes: {
          '/home': (context) => const HomeScreen(),
          '/signin': (context) => const SignInScreen(),
          '/register': (context) => const RegisterScreen(),
        },
        debugShowCheckedModeBanner: false,
      title: 'Spotify',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeNotifier.themeMode,
      //home: const RegisterScreen()
      //home: LoadingScreen(),
    );
  }

}
