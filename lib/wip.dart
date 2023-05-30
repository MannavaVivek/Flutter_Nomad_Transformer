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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> countryNames = [
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Germany',
    'France',
  ];

  final ScrollController _scrollController = ScrollController();
  bool _showLeftScrollButton = false;
  bool _showRightScrollButton = false;

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 200, // Adjust the scroll distance as needed
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 200, // Adjust the scroll distance as needed
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _showLeftScrollButton = _scrollController.offset > 0;
        _showRightScrollButton =
            _scrollController.offset < _scrollController.position.maxScrollExtent;
      });
      _scrollController.addListener(() {
        setState(() {
          _showLeftScrollButton = _scrollController.offset > 0;
          _showRightScrollButton =
              _scrollController.offset < _scrollController.position.maxScrollExtent;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final totalItemWidth = (countryNames.length * 116.0);
          final _showScrollButtons = totalItemWidth > constraints.maxWidth;

          return Stack(
            alignment: Alignment.center,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: Row(
                  children: countryNames.map((country) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
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
              ),
              if (_showScrollButtons && _showLeftScrollButton)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: _scrollLeft,
                  ),
                ),
              if (_showScrollButtons && _showRightScrollButton)
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: _scrollRight,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
