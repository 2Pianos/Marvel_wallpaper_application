import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        title: const Text('Marvel Wallpaper App'),
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
            return PageView.builder(
              controller: pageController,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return _getPageAtIndex(index, snapshot);
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
          label: 'Wallpaper',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorite',
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
      int index, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    switch (index) {
      case 0:
      return AllImages(snapshot: snapshot);
        break;
      case 1:
      return Home(snapshot: snapshot);
        break;
      case 2:
      return Favorites(snapshot: snapshot);
        break;
      default:
      return const CircularProgressIndicator();
        break;
    }
  }
}
