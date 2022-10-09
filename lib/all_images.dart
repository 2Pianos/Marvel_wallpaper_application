import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllImages extends StatelessWidget {
  const AllImages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Wallpapers').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7), 
            itemCount: snapshot.data?.docs.length,
            itemBuilder:(BuildContext context, int index) {
              return GridTile(
                child: InkResponse(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data?.docs.elementAt(index)['url'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    debugPrint('Tıklandı');
                  },
                )
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator(color: Colors.purpleAccent,));
        }
      }, 
    );
  }
}