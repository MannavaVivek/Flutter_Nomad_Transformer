import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Page")),
      body: const Center(child: Text("Welcome to the User Page!")),
    );
  }
}
