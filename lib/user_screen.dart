import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'user_provider.dart';
import 'hive_service.dart';
import 'theme_notifier.dart';
import 'pullable_widget.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String _username = '';
  String _quote = "Do I wake up every morning and ask you for Coffee Coffee Cream Cream?";
  bool _isDarkTheme = false;
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _loadUserData();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> _loadUserData() async {
    await HiveService.initHive();
    final userId = HiveService.getUserId();
    if (userId.isNotEmpty) {
      setState(() {
        _user = _auth.currentUser;
        _username = HiveService.getUsername();
        _quote = HiveService.getQuote();
        _imageUrl = HiveService.getAvatar();
      });
    }
  }

  Future<void> _getCurrentUser() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      setState(() {
        _user = currentUser;
      });

      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('user_data_personal')
          .doc(currentUser.uid)
          .get();
      if (userData.exists) {
        setState(() {
          _username = userData['username'];
          _quote = userData['quote'];
          _imageUrl = userData['avatar'];
        });
        HiveService.setUsername(_username);
        HiveService.setQuote(_quote);
        HiveService.setAvatar(_imageUrl);
      }
      final querySnapshot = await FirebaseFirestore.instance
        .collection('user_data_personal')
        .doc(currentUser.uid)
        .collection('posts')
        .get();
      final likedPostIds = querySnapshot.docs.map((doc) => doc.id).toList();
      HiveService.setLikedPosts(likedPostIds);
    }
  }

  void _signIn() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _showNoInternetDialog();
    } else {
      GoRouter.of(context).push('/signin');
    }
  }

  Future<void> _showNoInternetDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No internet connection'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You need internet connection to sign in.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _signOut() async {
    try {
      await _auth.signOut();
      setState(() {
        _user = null;
      });
      context.pushReplacement('/user');
      print('Signed out successfully');
      Provider.of<UserProvider>(context, listen: false).setUser(null);
    } catch (e) {
      print('Failed to sign out: $e');
    }
  }

  void _toggleTheme() {
    if (_isDarkTheme) {
      Provider.of<ThemeNotifier>(context, listen: false).setTheme(ThemeData.light());
    } else {
      Provider.of<ThemeNotifier>(context, listen: false).setTheme(ThemeData.dark());
    }
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }
  Widget buildButton(String label, void Function()? onPressed) {
    return Container(
      width: double.infinity,
      height: 48,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _user != null ? Colors.red : Colors.green,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                        width: 2.0,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      backgroundImage: CachedNetworkImageProvider(HiveService.getAvatar()),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_user != null)
                    Text(
                      'Hello $_username',
                      style: TextStyle(fontSize: 24),
                    ),
                  SizedBox(height: 20),
                  Container(
                    width: 300,
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "“",
                            style: GoogleFonts.satisfy(fontSize: 36,color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: _quote.isNotEmpty
                              ? Text(
                                  _quote,
                                  style: GoogleFonts.satisfy(fontSize: 18, color: Colors.black),
                                )
                              : Text(
                                  "Do I wake up every morning and ask you for Coffee Coffee Cream Cream?",
                                  style: GoogleFonts.satisfy(fontSize: 18, color: Colors.black),
                                  // set text color to black


                                ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "”",
                            style: GoogleFonts.satisfy(fontSize: 36, color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 20),
                        if (_user != null)
                          Text(_user!.displayName ?? ''),
                        if (_user == null)
                          buildButton('Sign In', _signIn),
                        if (_user != null)
                          buildButton('Sign Out', _signOut),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            // top: MediaQuery.of(context).size.height * 0.2,
            right: MediaQuery.of(context).size.width * -0.4,
            child: PullableWidget(
              onPull: _toggleTheme,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  context.go('/');
                });
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 34,
                    width: 34,
                    child: RiveAnimation.asset(
                      'assets/RiveAssets/icons.riv',
                      artboard: "HOME",
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                context.push('/search');
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 34,
                    width: 34,
                    child: RiveAnimation.asset(
                      'assets/RiveAssets/icons.riv',
                      artboard: "SEARCH",
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                context.go('/favorites');
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 34,
                    width: 34,
                    child: RiveAnimation.asset(
                      'assets/RiveAssets/icons.riv',
                      artboard: "LIKE/STAR",
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  // Do something for the user page
                });
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 34,
                    width: 34,
                    child: RiveAnimation.asset(
                      'assets/RiveAssets/icons.riv',
                      artboard: "USER",
                    ),
                  ),
                  Container(
                    height: 2,
                    width: 34,
                    color: Colors.white,
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
