import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';
import 'package:provider/provider.dart';

import 'blog_post.dart';
import 'blog_content.dart';
import 'user_provider.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const countryNames = [
    'Austria',
    'Belgium',
    'CzechRepublic',
    'France',
    'Germany',
    'Hungary',
    'Italy',
    'Luxembourg',
    'Netherlands',
    'Slovakia',
  ];

  static const countryUrls = {
    'Austria': '/country/austria',
    'Belgium': '/country/belgium',
    'CzechRepublic': '/country/czechrepublic',
    'France': '/country/france',
    'Germany': '/country/germany',
    'Hungary': '/country/hungary',
    'Italy': '/country/italy',
    'Luxembourg': '/country/luxembourg',
    'Netherlands': '/country/netherlands',
    'Slovakia': '/country/slovakia',
  };

  static const List<String> recommendedPosts = ['1', '2', '3'];

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:  PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              final userId = userProvider.userId;
              if (userId != "") {
                print('userId from homescreen: $userId (${userId.runtimeType}).');
              } else if (userId == null) {
                print('userId from homescreen is null.');
              } else {
                print('userId from homescreen is empty string.');
                print("${userProvider.userId}");
              }

              return AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  userId != "" ? 'Hello ${userProvider.userId}' : 'Hello Guest',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
                automaticallyImplyLeading: false,
              );
            },
          ),
        ),
        body: Align(
          alignment: Alignment.center,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 900),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Explore',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Courgette',
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (String country in HomeScreen.countryNames)
                              GestureDetector(
                                onTap: () {
                                  final countryUrl =
                                      HomeScreen.countryUrls[country];
                                  if (countryUrl != null) {
                                    context.push(countryUrl);
                                  }
                                },
                                child: Container(
                                  width: 120,
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.asset(
                                          'assets/images/${country.toLowerCase()}_unsplash.jpg',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        country,
                                        style: TextStyle(fontFamily: 'Nunito'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Recommended Reads',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Courgette',
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (String postId in HomeScreen.recommendedPosts)
                              Container(
                                width: 300,
                                height: 300,
                                child: BlogPostListItem(
                                  postId: postId,
                                  title: blogPosts[postId]!.title,
                                  summary: blogPosts[postId]!.summary,
                                  caption: blogPosts[postId]!.caption,
                                  imageUrl: blogPosts[postId]!.imageUrl,
                                  imageAttribution: blogPosts[postId]!.imageAttribution,
                                  country: blogPosts[postId]!.country,
                                  city: blogPosts[postId]!.city,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
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
                    // do something here if you wanna go home from home 
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
                    Container(
                      height: 2,
                      width: 34,
                      color: Colors.white,
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
                  setState(() {
                    context.push('/favorites');
                  });
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
                    context.push('/user');
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
