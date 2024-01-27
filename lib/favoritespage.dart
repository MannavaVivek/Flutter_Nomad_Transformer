import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'content_classes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'city_content_page.dart';

class FavoritesPage extends StatefulWidget {
  final Isar isar;

  const FavoritesPage({Key? key, required this.isar}) : super(key: key);

  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  late Future<List<City>> futureFavorites;
  List<City> favoriteCities = [];

  @override
  void initState() {
    super.initState();
    futureFavorites = fetchFavorites();
  }

  Future<List<City>> fetchFavorites() async {
    final user = FirebaseAuth.instance.currentUser?.uid ?? 'Guest';
    final userFavorites =
        await widget.isar.userFavorites.where().userIdEqualTo(user).findFirst();

    List<String> favBlogPosts = userFavorites?.favBlogPosts.toList() ?? [];
    List<City> favCities = [];

    for (String cityName in favBlogPosts) {
      var city = await widget.isar.citys
          .filter()
          .nameEqualTo(cityName, caseSensitive: false)
          .findFirst();

      if (city != null) {
        favCities.add(city);
      }
    }

    setState(() {
      favoriteCities = favCities;
    });

    return favCities;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        updateFirestoreFavorites();
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Your Favorite cities',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: FutureBuilder<List<City>>(
            future: futureFavorites,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: favoriteCities.length,
                  itemBuilder: (context, index) {
                    final city = snapshot.data![index];
                    bool isFavorite = true;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CityDetailsPage(
                              cityName: city.name,
                              isar: widget.isar,
                            ),
                          ),
                        ).then((value) => setState(() {
                              futureFavorites = fetchFavorites();
                            }));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 25),
                        height: 200, // Tile height
                        width: 300, // Tile width
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: 'https:${city.imageAssetURL}',
                                width: double.infinity, // Image width
                                height: 200, // Image height
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    const Center(child: Icon(Icons.error)),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  child: Container(
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors
                                              .black, // Bottom of the gradient is white
                                        ],
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      city.name,
                                      style: const TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .white), // Adjust text style as needed
                                    ),
                                  ),
                                )),
                            Positioned(
                                top: 165,
                                right: 15,
                                child: InkWell(
                                  onTap: () {
                                    // Toggle the favorite state immediately for UI responsiveness
                                    setState(() {
                                      isFavorite = !isFavorite;
                                      favoriteCities.remove(city);
                                    });

                                    updateIsarFavorites(city.name);
                                    // Update the local cache in the background
                                  },
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size:
                                        24.0, // You can adjust the size as needed
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Future<bool> updateIsarFavorites(String cityName) async {
    final user = FirebaseAuth.instance.currentUser?.uid ?? 'Guest';
    final userFavorites =
        await widget.isar.userFavorites.where().userIdEqualTo(user).findFirst();

    List<String> favBlogPosts = userFavorites?.favBlogPosts.toList() ?? [];

    if (favBlogPosts.contains(cityName)) {
      favBlogPosts.remove(cityName);
    }

    await widget.isar.writeTxn(() async {
      await widget.isar.userFavorites
          .put(UserFavorites(userId: user, favBlogPosts: favBlogPosts));
    });

    return true;
  }

  Future<void> updateFirestoreFavorites() async {
    print('Updating favorites in Firestore');
    try {
      // Fetch the user's favorite blog posts from Isar
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'Guest';
      if (userId == 'Guest') {
        return;
      }
      final userFavorites = await widget.isar.userFavorites
          .where()
          .userIdEqualTo(FirebaseAuth.instance.currentUser!.uid)
          .findFirst();

      if (userFavorites != null) {
        // Convert the fixed-length list to a growable list
        List<String> favBlogPosts = userFavorites.favBlogPosts.toList();

        // Update Firestore with the list of favorite blog posts
        await FirebaseFirestore.instance
            .collection('UserFavorites')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'favBlogPosts': favBlogPosts,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error updating Firestore favorites: $e');
      // Handle errors appropriately
    }
  }
}
