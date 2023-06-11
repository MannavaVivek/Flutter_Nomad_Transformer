import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

import 'blog_post.dart';
import 'hive_service.dart';
import 'blogpost_provider.dart';
import 'country_content_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<void> initHive() async {
    await HiveService.initHive();
  }

  List<String> get countryNames {
    final box = Hive.box(CountryProvider.boxName);
    return box.keys.cast<String>().toList();
  }

  Map<String, String> get countryUrls {
    final box = Hive.box(CountryProvider.boxName);
    return box.toMap().map((key, value) => MapEntry(key, value['url']));
  }

  Map<String, String> get countryImageUrls {
    final box = Hive.box(CountryProvider.boxName);
    return box.toMap().map((key, value) => MapEntry(key, value['imageUrl']));
  }

  Future<List<String>> fetchLikedPostIdsFromHive() async {
    final likedPosts = await HiveService.getLikedPosts();
    return likedPosts;
  }

  @override
  Widget build(BuildContext context) {
    const List<String> recommendedPosts = ['1', '2', '3'];

    return FutureBuilder(
      future: initHive(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();  // Show loading spinner
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');  // Show error message
        } else {
          // Once Hive has been initialized, return the widget as usual
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
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
                        backgroundColor: Theme.of(context).brightness == Brightness.light ? Color.fromARGB(117, 158, 158, 158) : Colors.white,
                        backgroundImage: CachedNetworkImageProvider(HiveService.getAvatar()),
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
                                      child: CachedNetworkImage(
                                        imageUrl: countryImageUrls[country] ?? '',
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
                            final blogPostProvider = Provider.of<BlogPostProvider>(context);
                            final blogPosts = blogPostProvider.blogPosts;

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
                                    return SizedBox.shrink(); // Return an empty widget
                                  }

                                  return GestureDetector(
                                    onTap: () => GoRouter.of(context).push('/post/$postId'),
                                    child: Container(
                                      height: 200, // Set the desired height of each item
                                      child: BlogPostListItemHome(
                                        postId: postId,
                                        title: blogPost.title,
                                        summary: blogPost.summary,
                                        caption: blogPost.caption,
                                        imageUrl: blogPost.imageUrl,
                                        imageAttribution: blogPost.imageAttribution,
                                        country: blogPost.country,
                                        city: blogPost.city,
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
    );
  }
}