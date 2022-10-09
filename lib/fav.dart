import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {

  final AsyncSnapshot<QuerySnapshot> snapshot;

  const Favorites({Key? key, required this.snapshot}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Favorites'));
  }
}