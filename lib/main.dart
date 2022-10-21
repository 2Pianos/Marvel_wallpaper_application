import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/constants.dart';
import 'package:wallpaper_app/pages.dart';
import 'package:wallpaper_app/providers/fav_wallpaper_manager.dart';
import 'firebase_options.dart';
import 'package:hive/hive.dart';

Future<void> main() async {
  await _initApp();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

Future<void> _initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  var docDir = await getApplicationDocumentsDirectory();
  Hive.init(docDir.path);
  
  var favBox = await Hive.openBox(FAV_BOX);
  if (favBox.get(FAV_LIST_KEY) == null) {
    favBox.put(FAV_LIST_KEY,  List<dynamic>.empty(growable: true));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => FavWallpaperManager(),
      child: MaterialApp(
        title: 'Marvel Türkiye',
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
          title: 'Marvel Türkiye',
        ),
      ),
    );
  }
}
