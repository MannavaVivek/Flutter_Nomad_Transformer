import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const MyApp());

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'post/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return BlogPostScreen(postId: id);
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Travel Stories'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          BlogPostListItem(
            postId: '1',
            title: 'Adventure in the Italy',
            summary: 'A thrilling journey through wine country...',
            imageUrl: 'assets/italy_unsplash.jpg',
            imageAttribution: 'Photo by Chris Karidis on Unsplash',
          ),
          BlogPostListItem(
            postId: '2',
            title: 'Discovering Paris',
            summary: 'The city of lights has so much to offer...',
            imageUrl: 'assets/paris_unsplash.jpg',
            imageAttribution: 'Photo by Mattia Righetti on Unsplash',
          ),
          // ...add more blog posts here
        ],
      ),
    );
  }
}

class BlogPostListItem extends StatefulWidget {
  final String postId;
  final String title;
  final String summary;
  final String imageUrl;
  final String imageAttribution;

  BlogPostListItem({
    Key? key,
    required this.postId,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.imageAttribution,
  }) : super(key: key);

  @override
  _BlogPostListItemState createState() => _BlogPostListItemState();
}

class _BlogPostListItemState extends State<BlogPostListItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        // on tap go to the blog post screen
        onTap: () => context.go('post/${widget.postId}'),
        onHover: (isHovering) {
          setState(() {
            _isHovering = isHovering;
          });
        },
        child: Card(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Image.asset(
                    widget.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  if (_isHovering)
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.black54,
                      child: Text(
                        widget.imageAttribution,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.summary,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BlogPostScreen extends StatelessWidget {
  const BlogPostScreen({Key? key, required this.postId}) : super(key: key);

  final String postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Post $postId'),
      ),
      body: Center(
        child: Text('Content of Blog Post $postId'),
      ),
    );
  }
}
