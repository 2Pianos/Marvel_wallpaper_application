import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/models/wallpapers.dart';
import 'package:wallpaper_app/providers/fav_wallpaper_manager.dart';

import 'all_images.dart';
import 'fav.dart';
import 'home.dart';

class Pages extends StatefulWidget {
  const Pages({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {

  final pageController = PageController(initialPage: 1);
  int currentSelected = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marvel Wallpapers'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.search),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Wallpapers').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
    
            var wallpapersList = List<Wallpaper>.empty(growable: true);
            var favWallpaperManager = Provider.of<FavWallpaperManager>(context);
    
            snapshot.data?.docs.forEach((documentSnapshot) {
              var wallpaper = Wallpaper.fromDocumentSnapshot(documentSnapshot);

              if (favWallpaperManager.isFavorite(wallpaper)) {
                wallpaper.isFavorite = true;
              }

              wallpapersList.add(wallpaper);
            });
    
            return PageView.builder(
              controller: pageController,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return _getPageAtIndex(index, wallpapersList);
              },
              onPageChanged: (int index) {
                setState(() {
                  currentSelected = index;
                });
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentSelected,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.image),
          label: 'Wallpapers',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pages),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
      ],
      onTap: (int index) {
        setState(() {
          currentSelected = index;
          pageController.animateToPage(currentSelected,
              duration: const Duration(milliseconds: 700),
              curve: Curves.fastOutSlowIn);
        });
      },
    );
  }

  Widget _getPageAtIndex(
      int index, List<Wallpaper> wallpaperList) {
    switch (index) {
      case 0:
      return AllImages(wallpapersList: wallpaperList);
        break;
      case 1:
      return Home(wallpapersList: wallpaperList);
        break;
      case 2:
      return Favorites(wallpapersList: wallpaperList);
        break;
      default:
      return const CircularProgressIndicator();
        break;
    }
  }
}
