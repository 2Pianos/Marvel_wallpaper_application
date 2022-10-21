import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/models/wallpapers.dart';
import 'package:wallpaper_app/providers/fav_wallpaper_manager.dart';
import 'package:wallpaper_app/wallpaper_gallery.dart';

class CategoryWallpapers extends StatefulWidget {
  final String category;

  const CategoryWallpapers({Key? key, required this.category})
      : super(key: key);

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
            var wallpapers =
                _getWallpapersOfCurrentCategory(snapshot.data?.docs);
    
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.7),
                itemCount: wallpapers.length,
                itemBuilder: (BuildContext context, int index) {
    
                  var favWallpaperManager = Provider.of<FavWallpaperManager>(context);
    
                  return GridTile(
                      child: InkResponse(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WallpaperGallery(
                            wallpaperList: wallpapers, 
                            initialPage: index,
                          ),
                        )
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 200.0,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(wallpapers.elementAt(index).url),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: const ShapeDecoration(
                              color: Color.fromARGB(225, 105, 54, 192),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(20.0)
                                )
                              )
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  wallpapers.elementAt(index).category,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (wallpapers.elementAt(index).isFavorite) {
                                      favWallpaperManager.addToFav(wallpapers.elementAt(index));
                                    } else {
                                      favWallpaperManager.removeFromFav(wallpapers.elementAt(index));
                                    }
                                    wallpapers.elementAt(index).isFavorite = !wallpapers.elementAt(index).isFavorite;
                                  }, 
                                  icon: Icon(
                                    wallpapers.elementAt(index).isFavorite 
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                )
                              ]
                            ),
                          ),
                        ),
                      ),
                    ),
                  ));
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  List<Wallpaper> _getWallpapersOfCurrentCategory(List<QueryDocumentSnapshot<Object?>>? docs) {
    var list = List<Wallpaper>.empty(growable: true);

    var favWallpaperManager = Provider.of<FavWallpaperManager>(context);

    docs?.forEach((document) {
      var wallpaper = Wallpaper.fromDocumentSnapshot(document);

      if (wallpaper.category == widget.category) {

        if (favWallpaperManager.isFavorite(wallpaper)) {
          wallpaper.isFavorite = true;
        }

        list.add(wallpaper);
      }
    });
    return list;
  }
}
