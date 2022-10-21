import 'package:flutter/material.dart';
import 'package:wallpaper_app/category_wallpaper.dart';
import 'package:wallpaper_app/models/wallpapers.dart';

class Home extends StatefulWidget {
  final List<Wallpaper> wallpapersList;

  const Home({Key? key, required this.wallpapersList}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> categories = [];
  final List<String> categoryImages = [];

  @override
  void initState() {
    super.initState();

    widget.wallpapersList.forEach((document) {
      var category = document.category;

      if (!categories.contains(category)) {
        categories.add(category);
        categoryImages.add(document.url);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, childAspectRatio: 0.7),
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return InkResponse(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return CategoryWallpapers(
                    category: categories.elementAt(index),);
                },
              ));
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 53, 14, 121)),
              alignment: Alignment.center,
              child: Text(
                categories.elementAt(index).toUpperCase(),
                style: const TextStyle(fontSize: 30.0, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          );
        });
  }
}

//image: DecorationImage(fit: BoxFit.cover,image: CachedNetworkImageProvider(categoryImages.elementAt(index),))
//kategorilere karaket imajı ekleme