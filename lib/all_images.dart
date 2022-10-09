import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class AllImages extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;

  const AllImages({Key? key, required this.snapshot}) : super(key: key);

  @override
  State<AllImages> createState() => _AllImagesState();
}

class _AllImagesState extends State<AllImages> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.7),
      itemCount: widget.snapshot.data?.docs.length,
      itemBuilder: (BuildContext context, int index) {
        return GridTile(
            child: InkResponse(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: CachedNetworkImage(
                imageUrl: widget.snapshot.data?.docs.elementAt(index)['url'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          onTap: () async {
            await _setWallpaper(index, context);
          },
        ));
      },
    );
  }

  Future<void> _setWallpaper(int index, BuildContext context) async {
    final imageurl = widget.snapshot.data?.docs.elementAt(index)['url'];
    
    Future<void> _setwallpaper(location) async {
      var file = await DefaultCacheManager().getSingleFile(imageurl);
      try {
        WallpaperManagerFlutter().setwallpaperfromFile(file, location);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wallpaper updated'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error Setting Wallpaper'),
          ),
        );
        debugPrint('e');
      }
    }
    
    var actionSheet = CupertinoActionSheet(
      title: const Text('Set As'),
      actions: [
        CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop(
                  _setwallpaper(WallpaperManagerFlutter.HOME_SCREEN));
            },
            child: const Text('Home')),
        CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop(
                  _setwallpaper(WallpaperManagerFlutter.LOCK_SCREEN));
            },
            child: const Text('Lock')),
        CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop(
                  _setwallpaper(WallpaperManagerFlutter.BOTH_SCREENS));
            },
            child: const Text('Both')),
      ],
    );
    showCupertinoModalPopup(
        context: context, builder: (context) => actionSheet);
              
  }
}
