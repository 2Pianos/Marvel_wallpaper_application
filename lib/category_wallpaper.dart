import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryWallpapers extends StatefulWidget {

  final String category;

  const CategoryWallpapers({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryWallpapers> createState() => _CategoryWallpapersState();
}

class _CategoryWallpapersState extends State<CategoryWallpapers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marvel Wallpaper App')),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Wallpapers').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {

            var categoryDocuments = snapshot.data?.docs.where((document) =>
              (document['tag'] == widget.category)
            );

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7),
              itemCount: categoryDocuments?.length,
              itemBuilder: (BuildContext context , int index) {
                return GridTile(
                  child: InkResponse(
                    onTap: () {
                      // wallpaper uygulamıyor . onu ayarlayacaz.
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: categoryDocuments?.elementAt(index)['url'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                );
              }
            );
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }
}