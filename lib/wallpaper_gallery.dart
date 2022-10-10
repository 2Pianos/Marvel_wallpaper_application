import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

class WallpaperGallery extends StatefulWidget {
  final List<DocumentSnapshot> wallpaperList;
  final int initialPage;

  const WallpaperGallery(
      {Key? key, required this.wallpaperList, required this.initialPage})
      : super(key: key);

  @override
  State<WallpaperGallery> createState() => _WallpaperGalleryState();
}

class _WallpaperGalleryState extends State<WallpaperGallery> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(children: [
        PhotoViewGallery.builder(
          pageController: _pageController,
          itemCount: widget.wallpaperList.length,
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(
                    widget.wallpaperList.elementAt(index)['url']));
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 100,
              color: Color(IconTheme.of(context).color!.value ^ 0xffffff),
              child: IconButton(
                  onPressed: () {
                    
                  }, icon: const Icon(Icons.format_paint)
              ),
            ),
          )
        )
      ]),
    );
  }
}