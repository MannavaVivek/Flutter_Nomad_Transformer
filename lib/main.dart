import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'user_provider.dart';
import 'blog_post.dart';
import 'home_screen.dart';
import 'country_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'user_screen.dart';
import 'hive_service.dart';
import 'signin_screen.dart';
import 'register_screen.dart';
import 'blog_content.dart';
import 'blogpost_provider.dart';
import 'uploader.dart';

// import 'blog_content.g.dart';

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
        GoRoute(
          path: 'signin', 
          builder: (context, state) => SigninScreen(),
        ),
        GoRoute(
          path: 'register', 
          builder: (context, state) => RegisterScreen(),
        )
      ],
    ),
  ],
);

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initHive();
  Hive.registerAdapter(BlogPostAdapter());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // uploadItemsToFirestore(); // uncomment to upload default items to firestore

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => BlogPostProvider()),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      await Hive.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
    );
  }
}
