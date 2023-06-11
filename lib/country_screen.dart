import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_stories/country_content_provider.dart';
import 'blog_post.dart';
import 'package:rive/rive.dart';
import 'blog_content.dart';
import 'hive_service.dart';
import 'package:provider/provider.dart';
import 'blogpost_provider.dart';
import 'country_content_provider.dart';

class CountryScreen extends StatefulWidget {
  final String countryName;

  const CountryScreen({required this.countryName});

  @override
  _CountryScreenState createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  bool _isExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  List<String> filteredPosts = [];

  String capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1); // Capitalize the first letter
  }

  List<String> exploreVariations = [
    "Immerse yourself in the richness of",
    "Venture into the heart of",
    "Unearth the wonders of",
    "Discover the timeless charm of",
    "Embark on a journey through the enchanting landscapes of",
    "Dive into the vibrant culture and history of",
    "Experience the diverse and captivating sights of",
    "Witness the unique blend of tradition and innovation in",
    "Set foot in the remarkable realm of",
    "Journey into the captivating allure of"
  ];

  String getCountryContent(String countryName) {
  var data = CountryProvider.getCountryData(countryName);
  if (data != null) {
    return data['content'];
  }
  return "No content available for $countryName";
}

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void navigateToBlogPost(String postId) async {
    GoRouter.of(context).push('/post/$postId').then((value) => (() {}));
  }

  Future<List<String>> fetchLikedPostIdsFromHive() async {
      final likedPosts = await HiveService.getLikedPosts();
      return likedPosts;
  }

  @override
  Widget build(BuildContext context) {
    print("Building CountryScreen for ${widget.countryName}");
    final countryName = widget.countryName;
    final capitalizedCountryName = countryName.substring(0, 1).toUpperCase() + countryName.substring(1);
    final countryContent = getCountryContent(capitalizedCountryName);
    final blogPostsForCountry = getBlogPostsForCountry(widget.countryName);

    int crossAxisCount = MediaQuery.of(context).size.width ~/ 320;
    crossAxisCount = crossAxisCount > 3 ? 3 : crossAxisCount;
    crossAxisCount = crossAxisCount > 0 ? crossAxisCount : 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Set the background color to transparent
        elevation: 0, // Remove the elevation
        centerTitle: true,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/transparent_logo.png', // Replace with the path to your logo image with text
              width: 300, // Adjust the width as needed
              height: 150, // Adjust the height as needed
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 320.0 * crossAxisCount.toDouble(),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "“",
                      style: GoogleFonts.satisfy(fontSize: 36),
                    ),
                  ],
                ),
                Text(
                  countryContent,
                  style: GoogleFonts.satisfy(fontSize: 18),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "”",
                      style: GoogleFonts.satisfy(fontSize: 36),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Explore ${capitalize(widget.countryName)}",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Courgette'),
                ),
                SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _isExpanded ? filteredPosts.length : blogPostsForCountry.length,
                  itemBuilder: (context, index) {
                    final blogPostProvider = Provider.of<BlogPostProvider>(context);
                    final blogPosts = blogPostProvider.blogPosts;
                    final postId = _isExpanded ? filteredPosts[index] : blogPostsForCountry[index].postId;
                    final post = blogPosts[postId];
                    return FutureBuilder<List<String>>(
                              future: fetchLikedPostIdsFromHive(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  final likedPostIds = snapshot.data ?? [];
                                  final isLiked = likedPostIds.contains(postId);

                                  return AspectRatio(
                                    aspectRatio: 1,
                                    child: GestureDetector(
                                      onTap: () => navigateToBlogPost(postId),
                                      child: Container(
                                        width: 300,
                                        height: 300,
                                        child: BlogPostListItemCountry(
                                          postId: post?.postId ?? '',
                                          title: post?.title ?? '',
                                          summary: post?.summary ?? '',
                                          caption: post?.caption ?? '',
                                          imageUrl: post?.imageUrl ?? '',
                                          imageAttribution: post?.imageAttribution.toString() ?? '',
                                          country: post?.country ?? '',
                                          city: post?.city ?? '',
                                          isLiked: isLiked,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                    
                  },
                ),
              ],
            ),
          ),
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
    );
  }

  List<BlogPost> getBlogPostsForCountry(String countryName) {
    // Fetch the blog posts from your data source based on the country
    List<BlogPost> blogPostsForCountry = [];
    final blogPostProvider = Provider.of<BlogPostProvider>(context);
    final blogPosts = blogPostProvider.blogPosts;
    blogPosts.forEach((id, post) {
      if (post.country.toLowerCase() == countryName.toLowerCase()) {
        blogPostsForCountry.add(post);
      }
    });
    return blogPostsForCountry;
  }
}
