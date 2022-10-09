import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/pages.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marvel Wallpaper App',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
            backgroundColor: Colors.black,
            centerTitle: false,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.deepPurpleAccent,
            unselectedItemColor: Colors.white70,
          ),
          progressIndicatorTheme:
              const ProgressIndicatorThemeData(color: Colors.purpleAccent)),
      home: const Pages(
        title: 'Marvel Wallpaper App',
      ),
    );
  }
}
