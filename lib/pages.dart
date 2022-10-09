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
  final pages = [
    const AllImages(),
    const Home(),
    const Favorites(),
  ];

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentSelected,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Wallpaper'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
        ],
        onTap: (int index) {
          setState(() {
            currentSelected = index;
            pageController.animateToPage(currentSelected,
                duration: const Duration(milliseconds: 700),
                curve: Curves.fastOutSlowIn);
          });
        },
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: pages.length,
        itemBuilder: (BuildContext context, int index) {
          return pages[index];
        },
        onPageChanged: (int index) {
          setState(() {
            currentSelected = index;
          });
        },
      ),
    );
  }
}
