import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'blog_post.dart';
import 'package:rive/rive.dart';
import 'blog_content.dart';
import 'hive_service.dart';

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
    final countryContent = getCountryContent(widget.countryName);
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

  String getCountryContent(String countryName) {
    switch (countryName) {
      case 'austria':
        return "Austria, the landlocked gem of Central Europe, radiates with its imperial history and rugged alpine terrain. The birthplace of Mozart, the country harmoniously blends its rich culture with magnificent landscapes. From the romantic streets of Vienna, the stunning beauty of the Salzkammergut lake region";
      case 'belgium':
        return "Belgium, a small country with a big heart, is a place where Medieval meets Modern. With an intoxicating mix of picturesque landscapes, rich history, and distinctive culinary traditions, Belgium offers an unforgettable experience. The cobblestone streets of Bruges, the vibrant heart of Brussels, and the historic charms of Antwerp allure travelers from across the globe. Known worldwide for its superb chocolates, waffles, and beers, Belgium is also a gastronomic paradise";
      case 'czechrepublic':
        return "The Czech Republic, heart of Central Europe, is a treasure trove of culture, history, and stunning architecture. This country, where the east meets west, enchants you with its fairy-tale castles, ancient squares, and intriguing folklore. The charm of Prague's ancient bridges and spires, the Moravian vineyards, and the remarkable landscapes of Bohemian Switzerland capture the imagination of every visitor";
      case 'france':
        return "France, synonymous with romance and sophistication, has been a cultural beacon for centuries. From the chic boulevards of Paris, the charm of Provencal countryside, to the glamorous French Riviera, France offers an immersive experience in art, history, and gastronomy. Home to some of the world's most acclaimed wines, cheeses, and patisseries, French cuisine is a sensory delight";
      case 'germany':
        return "Germany, a powerhouse of Europe, is a harmonious blend of timeless tradition and forward-thinking innovation. This country is known for its lush landscapes, from the stunning Bavarian Alps, the picturesque Black Forest, to the enchanting Rhine Valley. Germany's cities, like the vibrant capital Berlin, historic Munich, and enchanting Heidelberg, offer a journey through time from medieval architecture to modern art and culture";
      case 'hungary':
        return "Hungary, the land of Magyars, mesmerizes visitors with its unique blend of Eastern and Western cultures. From the enchanting streets of Budapest, known as the 'Paris of the East', the pristine Lake Balaton, to the historic wine region of Eger, Hungary is full of fascinating surprises. Experience the rejuvenating thermal baths, delve into the flavorsome Hungarian cuisine with its spicy goulash and mouth-watering pastries, and immerse yourself in the country's profound history and vibrant folklore";
      case 'luxembourg':
        return "Luxembourg, one of Europe's smallest nations, holds grand surprises in its green heart. This multilingual country brims with castles, forests, and picturesque villages, with the cosmopolitan capital city offering a contrast with its blend of modern and medieval architecture. From the rugged beauty of the Ardennes, the sun-drenched vineyards of the Moselle, to the unique rock formations of Mullerthal, Luxembourg captures the imagination";
      case 'netherlands':
        return "The Netherlands, often known as Holland, is a country that captivates with its ingenious mix of tradition and innovation. Famous for its iconic windmills, colorful tulip fields, and charming canals, the country showcases its bond with nature in every corner. From the artistic heritage of Amsterdam, the historic university city of Utrecht, to the modern architecture of Rotterdam, the Netherlands offers diverse experiences";
      case 'slovakia':
        return "Slovakia, tucked away in the heart of Europe, is a hidden gem with rich natural beauty and fascinating history. From the majestic peaks of High Tatras, the ancient castles dotting the landscape, to the charming old town of Bratislava, Slovakia is a haven for nature and history lovers alike. Slovak cuisine, with its comforting soups, hearty dumplings, and delicious pastries, adds to the country's allure";
      case 'italy':
        return "Italy, a land of unparalleled beauty, is a symphony of stunning landscapes, rich history, and profound culture. Known as the birthplace of the Renaissance, Italy boasts numerous works of art and architecture that take your breath away. Its cities bustle with life and color, each with its own distinct character and charm. From the romantic canals of Venice, the majestic Colosseum of Rome, to the scenic vineyards of Tuscany, Italy beckons travelers with its irresistible allure";
      default:
        return "No content available for " + countryName;
    }
  }

  List<BlogPost> getBlogPostsForCountry(String countryName) {
    // Fetch the blog posts from your data source based on the country
    List<BlogPost> blogPostsForCountry = [];
    blogPosts.forEach((id, post) {
      if (post.country.toLowerCase() == countryName.toLowerCase()) {
        blogPostsForCountry.add(post);
      }
    });
    return blogPostsForCountry;
  }
}
