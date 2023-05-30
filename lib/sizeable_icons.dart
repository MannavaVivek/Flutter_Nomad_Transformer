import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Home Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<String> countryNames = [
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Germany',
    'France',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final availableWidth = constraints.maxWidth;
          final itemWidth = 120.0;
          final spacing = 8.0;
          final maxItemsPerRow = (availableWidth / (itemWidth + spacing)).floor();

          return SingleChildScrollView(
            child: Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: countryNames.map((country) {
                return Container(
                  width: (availableWidth - (maxItemsPerRow - 1) * spacing) / maxItemsPerRow,
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/paris_unsplash.jpg',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(country),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
