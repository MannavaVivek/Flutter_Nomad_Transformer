import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'blog_post.dart';
import 'home_screen.dart';
import 'country_screen.dart';

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
        GoRoute(
          path: 'country/:name',
          builder: (context, state) {
            final countryName = state.pathParameters['name'];
            return CountryScreen(countryName: countryName!);
          },
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
      debugShowCheckedModeBanner: false,
    );
  }
}

class _ResizeObserver extends WidgetsBindingObserver {
  final VoidCallback onResize;

  _ResizeObserver({required this.onResize});

  @override
  void didChangeMetrics() {
    onResize();
  }
}
