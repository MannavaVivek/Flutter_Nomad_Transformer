import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'HomePage.dart'; // Import your pages
import 'SearchPage.dart';
import 'FavoritesPage.dart';
import 'UserPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    FavoritesPage(),
    UserPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showBackDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you want to leave this page?',
          ),
          actions: <Widget>[
            TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Stay'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Leave'),
              onPressed: () {
                Navigator.pop(context);
                // exit the app
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        _showBackDialog();
      },
      child: Scaffold(
        body: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 6.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Home Button - placed here for symmetry but will be invisible
              IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () => _onItemTapped(0)),

              // Search Button
              IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _onItemTapped(1)),

              // Favorites Button
              IconButton(
                  icon: const Icon(Icons.star),
                  onPressed: () => _onItemTapped(2)),

              // User Button
              IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () => _onItemTapped(3)),
            ],
          ),
        ),
      ),
    );
  }
}
