import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class FavoritesPage extends StatelessWidget {
  final Isar isar;

  FavoritesPage({Key? key, required this.isar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites Page")),
      body: const Center(
        child: Text("Welcome to the Favorites Page!"),
      ),
    );
  }
}
