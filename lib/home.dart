import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/category_wallpaper.dart';

class Home extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;

  const Home({Key? key, required this.snapshot}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> categories = [];
  final List<String> categoryImages = [];

  @override
  void initState() {
    super.initState();

    widget.snapshot.data?.docs.forEach((document) {
      var category = document['tag'];

      if (!categories.contains(category)) {
        categories.add(category);
        categoryImages.add(document['url']);
      }
    });
  }

  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 0.7),
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return InkResponse(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder:(context) {
                return CategoryWallpapers(category: categories.elementAt(index));
              },
              ));
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        categoryImages.elementAt(index),
                      ))),
              alignment: Alignment.center,
              child: Text(
                categories.elementAt(index).toUpperCase(),
                style: const TextStyle(fontSize: 30.0, color: Colors.white),
              ),
            ),
          );
        });
  }
}
