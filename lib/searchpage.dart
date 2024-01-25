import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class SearchPage extends StatelessWidget {
  final Isar isar;

  const SearchPage({Key? key, required this.isar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Page")),
      body: const Center(child: Text("Welcome to the Search Page!")),
    );
  }
}
