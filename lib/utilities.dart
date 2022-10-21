import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

Future<void> setWallpaper({required BuildContext context, required String url}) async {

  Future<void> _setwallpaper(location) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(
        ratioX: MediaQuery.of(context).size.width,
        ratioY: MediaQuery.of(context).size.height,),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Image Cropper',
            toolbarColor: Colors.deepPurple,
            activeControlsWidgetColor: Colors.deepPurple,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false
          ),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    try {
      WallpaperManagerFlutter().setwallpaperfromFile(croppedFile, location);
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
    }
  }

  var actionSheet = CupertinoActionSheet(
    title: const Text('Options', style: TextStyle(color: Colors.black)),
    actions: [
      CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context)
                .pop(_setwallpaper(WallpaperManagerFlutter.HOME_SCREEN));
          },
          child: const Text('Set As Home', style: TextStyle(color: Colors.deepPurpleAccent))),
      CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context)
                .pop(_setwallpaper(WallpaperManagerFlutter.LOCK_SCREEN));
          },
          child: const Text('Set As Lock', style: TextStyle(color: Colors.deepPurpleAccent),)),
      CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context)
                .pop(_setwallpaper(WallpaperManagerFlutter.BOTH_SCREENS));
          },
          child: const Text('Set As Both', style: TextStyle(color: Colors.deepPurpleAccent))),
    ],
  );
  showCupertinoModalPopup(context: context, builder: (context) => actionSheet, filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10));
}