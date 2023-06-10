import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    return Future.delayed(Duration(seconds: 3), () {
      GoRouter.of(context).go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
            width: 350,
            height: 350, // Replace with your logo asset
          child: Image.asset('assets/images/splash_undraw.png')), // Replace with your logo asset
      ),
    );
  }
}
