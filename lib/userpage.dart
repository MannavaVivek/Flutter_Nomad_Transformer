import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class UserPage extends StatelessWidget {
  final Isar isar;

  UserPage({Key? key, required this.isar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Page")),
      body: const Center(
        child: Text("Welcome to the User Page!"),
      ),
    );
  }
}
