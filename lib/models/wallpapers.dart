import 'package:cloud_firestore/cloud_firestore.dart';

class Wallpaper {
  final String url;
  final String category;
  final String name;
  final String id;
  bool isFavorite;

  Wallpaper.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : url = snapshot.data().toString().contains('url') ? snapshot.get('url') : '',
        category = snapshot.data().toString().contains('tag') ? snapshot.get('tag') : '',
        name = snapshot.data().toString().contains('name') ? snapshot.get('name') : '',
        id = snapshot.id,
        isFavorite = false;
}