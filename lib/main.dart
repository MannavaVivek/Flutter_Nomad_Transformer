import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'user_provider.dart';
import 'blog_post.dart';
import 'home_screen.dart';
import 'country_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'user_screen.dart';


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
        GoRoute(
          path: 'search',
          builder: (context, state) => const SearchScreen(),
        ),
        // route for favorites
        GoRoute(
          path: 'favorites',
          builder: (context, state) => FavoritesScreen(),
        ),
        // route for user
        GoRoute(
          path: 'user',
          builder: (context, state) => UserScreen(),
        ),
      ],
    ),
  ],
);

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // This is the last thing you need to add. 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ));
}

class MyApp extends StatelessWidget {
  // MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
          routerConfig: _router,
          debugShowCheckedModeBanner: false,
          scrollBehavior: MyCustomScrollBehavior(),
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
