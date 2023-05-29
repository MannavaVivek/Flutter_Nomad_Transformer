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
          path: 'post1',
          builder: (context, state) => BlogPostScreen(postId: '1'),
        ),
        GoRoute(
          path: 'post2',
          builder: (context, state) => BlogPostScreen(postId: '2'),
        ),
        GoRoute(
          path: 'post3',
          builder: (context, state) => BlogPostScreen(postId: '3'),
        ),
        GoRoute(
          path: 'post4',
          builder: (context, state) => BlogPostScreen(postId: '4'),
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
        title: const Text('Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => context.go('post1'),
            child: const Text('Go to Blog Post 1'),
          ),
          TextButton(
            onPressed: () => context.go('post2'),
            child: const Text('Go to Blog Post 2'),
          ),
          TextButton(
            onPressed: () => context.go('post3'),
            child: const Text('Go to Blog Post 3'),
          ),
          TextButton(
            onPressed: () => context.go('post4'),
            child: const Text('Go to Blog Post 4'),
          ),
        ],
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
