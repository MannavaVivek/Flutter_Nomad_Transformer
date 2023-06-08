import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'user_provider.dart';
import 'blog_post.dart';
import 'blog_content.dart';
import 'hive_service.dart';
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<BlogPost> likedPosts = [];

  @override
  void initState() {
    super.initState();
    fetchLikedPosts();
  }

  Future<void> fetchLikedPosts() async {
    final likedPostIds = await HiveService.getLikedPosts();
    final allBlogPosts = blogPosts.values.toList();

    setState(() {
      likedPosts = allBlogPosts.where((post) => likedPostIds.contains(post.postId)).toList();
    });
  }

  void navigateToBlogPost(String postId) async {
    GoRouter.of(context).push('/post/$postId').then((value) => (() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Listen to changes in likedPostIds
        final likedPostIds = HiveService.getLikedPosts();
        final userId = HiveService.getUserId();

        // Update the likedPosts when likedPostIds change
        likedPosts = blogPosts.values.where((post) => likedPostIds.contains(post.postId)).toList();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            titleSpacing: 8,
            title: Align(
              alignment: Alignment.center,
              child: Text('Favorites Screen',
                  style: TextStyle(
                    color: Color.fromARGB(214, 62, 117, 219),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: (likedPosts.isEmpty)
                ? Column(
                    children: [
                      SizedBox(
                        height: 300,
                        width: 300,
                        child: const RiveAnimation.asset(
                          'assets/RiveAssets/cat_no_results_found.riv',
                          stateMachines: ['State Machine 1'],
                        ),
                      ),
                      if (userId == 'Guest' || userId == '')
                        SizedBox(
                          width: 250,
                          child: Text(
                            "Oops! Looks like you haven't logged in yet. Remember, every journey starts with a single step, and yours starts with logging in!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(181, 106, 133, 184),
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      else if (likedPosts.isEmpty)
                        SizedBox(
                          width: 250,
                          child: Text(
                            "Hmm, your list of liked posts seems to be taking a break. No worries though! Take a stroll through our blog and discover some amazing content to light up this space.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(181, 106, 133, 184),
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  )
                : ListView.builder(
                    itemCount: likedPosts.length,
                    itemBuilder: (context, index) {
                      final blogPost = likedPosts[index];

                      return GestureDetector(
                        onTap: () => navigateToBlogPost(blogPost.postId),
                        child: Container(
                          height: 200, // Set the desired height of each item
                          child: BlogPostListItemHome(
                            postId: blogPost.postId,
                            title: blogPost.title,
                            summary: blogPost.summary,
                            caption: blogPost.caption,
                            imageUrl: blogPost.imageUrl,
                            imageAttribution: blogPost.imageAttribution,
                            country: blogPost.country,
                            city: blogPost.city,
                            isLiked: true,
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
                    context.go('/');
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 34,
                        width: 34,
                        child: RiveAnimation.asset(
                          'assets/RiveAssets/icons.riv',
                          artboard: "HOME",
                          stateMachines: ['State Machine 1'],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.go('/search');
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
                      // Do something for the favorites page
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
                    context.go('/user');
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
        );
      },
    );
  }
}