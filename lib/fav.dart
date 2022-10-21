import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/models/wallpapers.dart';
import 'package:wallpaper_app/providers/fav_wallpaper_manager.dart';
import 'package:wallpaper_app/wallpaper_gallery.dart';

class Favorites extends StatefulWidget {
  final List<Wallpaper> wallpapersList;

  const Favorites({Key? key, required this.wallpapersList}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {

    var wallpapers = widget.wallpapersList.where((wallpaper) => wallpaper.isFavorite).toList();

    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.7),
        itemCount: wallpapers.length,
        itemBuilder: (BuildContext context, int index) {
          var favWallpaperManager = Provider.of<FavWallpaperManager>(context);

          return GridTile(
              child: InkResponse(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => WallpaperGallery(
                  wallpaperList: wallpapers,
                  initialPage: index,
                ),
              ));
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
                    image: CachedNetworkImageProvider(
                        wallpapers.elementAt(index).url),
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: const ShapeDecoration(
                        color: Color.fromARGB(225, 105, 54, 192),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(20.0)))),
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
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
                                favWallpaperManager
                                    .removeFromFav(wallpapers.elementAt(index));
                              } else {
                                favWallpaperManager
                                    .addToFav(wallpapers.elementAt(index));
                              }
                              wallpapers.elementAt(index).isFavorite =
                                  !wallpapers.elementAt(index).isFavorite;
                            },
                            icon: Icon(
                              wallpapers.elementAt(index).isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
                          )
                        ]),
                  ),
                ),
              ),
            ),
          ));
        });
  }
}
