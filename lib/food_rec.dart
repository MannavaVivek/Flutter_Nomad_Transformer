import 'package:flutter/material.dart';

class FoodRecommendationScreen extends StatelessWidget {
  final String postId;

  const FoodRecommendationScreen({Key? key, required this.postId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Use the postId to fetch and display food recommendations for the city

    return Scaffold(
      appBar: AppBar(
        title: Text('Food Recommendations'),
      ),
      body: Center(
        child: Text('Food recommendations for $postId'),
      ),
    );
  }
}
