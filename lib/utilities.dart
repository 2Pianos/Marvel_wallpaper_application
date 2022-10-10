import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

Future<void> setWallpaper({required BuildContext context, required String url}) async {

  Future<void> _setwallpaper(location) async {
    var file = await DefaultCacheManager().getSingleFile(url);
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
            Navigator.of(context)
                .pop(_setwallpaper(WallpaperManagerFlutter.HOME_SCREEN));
          },
          child: const Text('Home')),
      CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context)
                .pop(_setwallpaper(WallpaperManagerFlutter.LOCK_SCREEN));
          },
          child: const Text('Lock')),
      CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context)
                .pop(_setwallpaper(WallpaperManagerFlutter.BOTH_SCREENS));
          },
          child: const Text('Both')),
    ],
  );
  showCupertinoModalPopup(context: context, builder: (context) => actionSheet);
}