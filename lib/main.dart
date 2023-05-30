import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BlogPost {
  final String title;
  final String content;

  const BlogPost({required this.title, required this.content});
}

final blogPosts = {
  '1': const BlogPost(
    title: 'Adventure in Italy: A Journey Through Wine Country',
    content: 'From the rolling vineyards of Tuscany to the historic cellars of Piedmont, '
        'join us on an unforgettable tour through the wine regions of Italy.',
  ),
  '2': const BlogPost(
    title: 'Discovering Paris: The City of Lights',
    content: 'Paris, a city known for its art, architecture, and cafe culture. '
        'Experience the grandeur of the Eiffel Tower, the charm of Montmartre, '
        'and the elegance of the Louvre on this comprehensive journey through the City of Lights.',
  ),
};

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'post/:id',
          builder: (context, state) => BlogPostScreen(postId: state.pathParameters['id']!),
        ),
      ],
    ),
  ],
);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
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
          // ignore: prefer_const_constructors
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

class BlogPostListItem extends StatelessWidget {
  final String postId;
  final String title;
  final String summary;
  final String imageUrl;
  final String imageAttribution;

  const BlogPostListItem({
    Key? key,
    required this.postId,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.imageAttribution,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/post/$postId'),
      child: Card(
        child: Column(
          children: [
            Image.network(
              imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    summary,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
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
    final post = blogPosts[postId] ?? const BlogPost(title: '', content: 'No content available for this post');
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PostContent(post: post),
        ),
      ),
    );
  }
}

class PostContent extends StatelessWidget {
  final BlogPost post;

  const PostContent({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          post.title,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Text(
          post.content,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
