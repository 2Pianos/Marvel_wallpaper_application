import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/models/wallpapers.dart';
import 'package:wallpaper_app/providers/fav_wallpaper_manager.dart';
import 'package:wallpaper_app/utilities.dart';

class WallpaperGallery extends StatefulWidget {
  final List<Wallpaper> wallpaperList;
  final int initialPage;

  const WallpaperGallery(
      {Key? key, required this.wallpaperList, required this.initialPage})
      : super(key: key);

  @override
  State<WallpaperGallery> createState() => _WallpaperGalleryState();
}

class _WallpaperGalleryState extends State<WallpaperGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    _currentIndex = widget.initialPage;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context,) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {  

          var favWallpaperManager = Provider.of<FavWallpaperManager>(context);

          return Stack(children: [
          PhotoViewGallery.builder(
            pageController: _pageController,
            itemCount: widget.wallpaperList.length,
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(
                  widget.wallpaperList.elementAt(index).url
                )
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 200,
                color: Color(IconTheme.of(context).color!.value ^ 0xffffff),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await _downloadWallpaper(context);
                      }, 
                      icon: const Icon(Icons.download)
                    ),
                    IconButton(
                      onPressed: () {
                        if (widget.wallpaperList.elementAt(_currentIndex).isFavorite) {
                          favWallpaperManager.removeFromFav(
                            widget.wallpaperList.elementAt(_currentIndex)
                          );
                        } else {
                          favWallpaperManager.addToFav(
                            widget.wallpaperList.elementAt(_currentIndex)
                          );
                        }
                        widget.wallpaperList.elementAt(_currentIndex).isFavorite = !widget.wallpaperList.elementAt(_currentIndex).isFavorite;
                      },
                      icon: Icon(
                        widget.wallpaperList.elementAt(_currentIndex).isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                        color: Colors.red,
                      )
                    ),
                    IconButton(
                        onPressed: () {
                          setWallpaper(
                            context: context, 
                            url: widget.wallpaperList.elementAt(_currentIndex).url,
                            );
                        }, icon: const Icon(Icons.format_paint)
                    ),
                  ],
                ),
              ),
            )
          )
        ]);
        },
      ),
    );
  }

  Future<void> _downloadWallpaper(BuildContext context) async {
    var status = await Permission.storage.request();
    
    if (status.isGranted) {
      try {
      var imageId = await ImageDownloader.downloadImage(
        widget.wallpaperList.elementAt(_currentIndex).url,
        destination: AndroidDestinationType.directoryPictures,
      );
          
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Download Completed'),
          action: SnackBarAction(label: 'Open', onPressed: () async {
            var path = await ImageDownloader.findPath(imageId!);
            await ImageDownloader.open(path!);
          }),
        )
      );  
        
      } on PlatformException catch (error) {
        print(error);
      }
    } else {
      showOpenSettingsAlert(context);
    }
  }

  void showOpenSettingsAlert(BuildContext context) {
    showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Need access to storage'),
        actions: [
          ElevatedButton(
            onPressed: () {
              openAppSettings();
            }, 
            child: const Text('Open Settings'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            }, 
            child: const Text('Cancel')
          ),
        ],
    ));
  }
}