import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';
import 'package:provider/provider.dart';

import 'blog_post.dart';
import 'blog_content.dart';
import 'user_provider.dart';
import 'hive_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    void initState() async {
      await HiveService.initHive();
    }

    const countryNames = [
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

    const countryUrls = {
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

    const List<String> recommendedPosts = ['1', '2', '3'];

    Future<List<String>> fetchLikedPostIdsFromHive() async {
      final likedPosts = await HiveService.getLikedPosts();
      return likedPosts;
    }

    initState();
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: false,
                titleSpacing: 8,
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hello, ${HiveService.getUsername()}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                leading: null,
                automaticallyImplyLeading: false,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: 150,
                      height: 150,
                      //have the avatar image to the right with a margin of 10
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/wakanda_unsplash.jpg'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'Explore',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Courgette',
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (String country in countryNames)
                            GestureDetector(
                              onTap: () {
                                final countryUrl = countryUrls[country];
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'Recommended Reads',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Courgette',
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        height: 200.0 * recommendedPosts.length,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: recommendedPosts.length,
                          itemBuilder: (context, index) {
                            final postId = recommendedPosts[index];
                            return FutureBuilder<List<String>>(
                              future: fetchLikedPostIdsFromHive(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  final likedPostIds = snapshot.data ?? [];
                                  final isLiked = likedPostIds.contains(postId);

                                  final blogPost = blogPosts[postId];

                                  if (blogPost == null) {
                                    print('blogPost with postId: $postId is null');
                                  }

                                  return GestureDetector(
                                    onTap: () => GoRouter.of(context).push('/post/$postId'),
                                    child: Container(
                                      height: 200, // Set the desired height of each item
                                      child: BlogPostListItemHome(
                                        postId: postId,
                                        title: blogPost?.title ?? 'Unknown',
                                        summary: blogPost?.summary ?? 'Unknown',
                                        caption: blogPost?.caption ?? 'Unknown',
                                        imageUrl: blogPost?.imageUrl ?? 'Unknown',
                                        imageAttribution: blogPost?.imageAttribution ?? 'Unknown',
                                        country: blogPost?.country ?? 'Unknown',
                                        city: blogPost?.city ?? 'Unknown',
                                        isLiked: isLiked,
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
                  // do something here if you wanna go home from home
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
                  context.push('/favorites');
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
                  context.push('/user');
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
