import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wallpaper_app/utilities.dart';
import 'package:wallpaper_app/wallpaper_gallery.dart';

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
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return WallpaperGallery(
                          wallpaperList: widget.snapshot.data!.docs, 
                          initialPage: index,
                        );
                      },
                    )
                  );
                },
                child: CachedNetworkImage(
                  imageUrl: widget.snapshot.data?.docs.elementAt(index)['url'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          onTap: () async {
            await setWallpaper(context: context, url: widget.snapshot.data?.docs.elementAt(index)['url']);
          },
        ));
      },
    );
  }
}
