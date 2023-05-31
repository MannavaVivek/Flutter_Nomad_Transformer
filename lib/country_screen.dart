import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'blog_post.dart';
import 'package:go_router/go_router.dart';

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

  @override
  Widget build(BuildContext context) {
    // Use the countryName to retrieve the content for the country
    final countryContent = getCountryContent(widget.countryName);
    // Use the countryName to retrieve blog posts for the country
    final blogPostsForCountry = getBlogPostsForCountry(widget.countryName);

    int crossAxisCount = MediaQuery.of(context).size.width ~/ 320;
    crossAxisCount = crossAxisCount > 3 ? 3 : crossAxisCount;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        leading: Tooltip(
          message: 'Home',
          child: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              context.go('/');
            },
          ),
        ),
        title: _isExpanded
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search...',
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(width: 0, style: BorderStyle.none),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      filteredPosts = blogPostsForCountry
                          .where((post) =>
                              post.city.toLowerCase().contains(value.toLowerCase()))
                          .map((post) => post.postId)
                          .toList();
                    } else {
                      filteredPosts = [];
                    }
                  });
                },
              )
            : Text("Explore ${capitalize(widget.countryName)}"),
        actions: [
          IconButton(
            icon: Icon(_isExpanded ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
                if (!_isExpanded) {
                  _searchController.clear();
                  filteredPosts = []; // Clear the filtered posts
                }
              });
            },
          ),
        ],
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
                    return ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: 300, height: 300),
                      child: BlogPostListItem(
                          postId: post?.postId ?? '',
                          title: post?.title ?? '',
                          summary: post?.summary ?? '',
                          caption: post?.caption ?? '',
                          imageUrl: post?.imageUrl ?? '',
                          imageAttribution: post?.imageAttribution.toString() ?? '',
                          country: post?.country ?? '',
                          city: post?.city ?? '',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getCountryContent(String countryName) {
      switch (countryName) {
        case 'austria':
          return "Austria, the landlocked gem of Central Europe, radiates with its imperial history and rugged alpine terrain. The birthplace of Mozart, the country harmoniously blends its rich culture with magnificent landscapes. From the romantic streets of Vienna, the stunning beauty of the Salzkammergut lake region, to the snow-capped peaks of Tyrol, Austria invites its visitors to immerse themselves in a majestic symphony of culture, history, and nature. Don't miss the chance to indulge in Austria's delectable cuisine with its world-renowned pastries and comforting hearty dishes.";
        case 'belgium':
          return "Belgium, a small country with a big heart, is a place where Medieval meets Modern. With an intoxicating mix of picturesque landscapes, rich history, and distinctive culinary traditions, Belgium offers an unforgettable experience. The cobblestone streets of Bruges, the vibrant heart of Brussels, and the historic charms of Antwerp allure travelers from across the globe. Known worldwide for its superb chocolates, waffles, and beers, Belgium is also a gastronomic paradise. Explore the diversity and richness of Belgium, a country that effortlessly blends old and new.";
        case 'czechrepublic':
          return "The Czech Republic, heart of Central Europe, is a treasure trove of culture, history, and stunning architecture. This country, where the east meets west, enchants you with its fairy-tale castles, ancient squares, and intriguing folklore. The charm of Prague's ancient bridges and spires, the Moravian vineyards, and the remarkable landscapes of Bohemian Switzerland capture the imagination of every visitor. Czech cuisine, with its hearty stews and world-renowned beer, provides a culinary journey that complements the country's rich cultural exploration.";
        case 'france':
          return "France, synonymous with romance and sophistication, has been a cultural beacon for centuries. From the chic boulevards of Paris, the charm of Provencal countryside, to the glamorous French Riviera, France offers an immersive experience in art, history, and gastronomy. Home to some of the world's most acclaimed wines, cheeses, and patisseries, French cuisine is a sensory delight. France invites you to step into a world of refined culture, unparalleled culinary adventures, and experiences steeped in history and tradition.";
        case 'germany':
          return "Germany, a powerhouse of Europe, is a harmonious blend of timeless tradition and forward-thinking innovation. This country is known for its lush landscapes, from the stunning Bavarian Alps, the picturesque Black Forest, to the enchanting Rhine Valley. Germany's cities, like the vibrant capital Berlin, historic Munich, and enchanting Heidelberg, offer a journey through time from medieval architecture to modern art and culture. Germany also holds high esteem for its culinary delights, including diverse breads, sausages, and, of course, its world-famous beers. Explore the breadth and depth of Germany, a country where history and progress coexist.";
        case 'hungary':
          return "Hungary, the land of Magyars, mesmerizes visitors with its unique blend of Eastern and Western cultures. From the enchanting streets of Budapest, known as the 'Paris of the East', the pristine Lake Balaton, to the historic wine region of Eger, Hungary is full of fascinating surprises. Experience the rejuvenating thermal baths, delve into the flavorsome Hungarian cuisine with its spicy goulash and mouth-watering pastries, and immerse yourself in the country's profound history and vibrant folklore. Hungary invites you to uncover its magical charm and mystique.";
        case 'luxembourg':
          return "Luxembourg, one of Europe's smallest nations, holds grand surprises in its green heart. This multilingual country brims with castles, forests, and picturesque villages, with the cosmopolitan capital city offering a contrast with its blend of modern and medieval architecture. From the rugged beauty of the Ardennes, the sun-drenched vineyards of the Moselle, to the unique rock formations of Mullerthal, Luxembourg captures the imagination. The country's refined cuisine, influenced by its neighbors, completes the enriching Luxembourgish experience. Discover the hidden delights of Luxembourg, a country that effortlessly balances rural tranquility with urban sophistication.";
        case 'netherlands':
          return "The Netherlands, often known as Holland, is a country that captivates with its ingenious mix of tradition and innovation. Famous for its iconic windmills, colorful tulip fields, and charming canals, the country showcases its bond with nature in every corner. From the artistic heritage of Amsterdam, the historic university city of Utrecht, to the modern architecture of Rotterdam, the Netherlands offers diverse experiences. With Dutch cheeses, herring, and pancakes as culinary highlights, the country promises a delightful gastronomic journey. The Netherlands invites you to experience its laid-back charm and inventive spirit.";
        case 'slovakia':
          return "Slovakia, tucked away in the heart of Europe, is a hidden gem with rich natural beauty and fascinating history. From the majestic peaks of High Tatras, the ancient castles dotting the landscape, to the charming old town of Bratislava, Slovakia is a haven for nature and history lovers alike. Slovak cuisine, with its comforting soups, hearty dumplings, and delicious pastries, adds to the country's allure. Whether you're exploring the rustic countryside or delving into the vibrant city life, Slovakia offers an unforgettable adventure.";
        case 'italy':
          return "Italy, a land of unparalleled beauty, is a symphony of stunning landscapes, rich history, and profound culture. Known as the birthplace of the Renaissance, Italy boasts numerous works of art and architecture that take your breath away. Its cities bustle with life and color, each with its own distinct character and charm. From the romantic canals of Venice, the majestic Colosseum of Rome, to the scenic vineyards of Tuscany, Italy beckons travelers with its irresistible allure. The country's rich gastronomy, marked by world-renowned wines, freshly baked bread, delectable cheeses, and pizzas, makes for a culinary adventure in its own right. Experience the Italian 'la dolce vita' and explore the many facets of this captivating country.";
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
