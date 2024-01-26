import 'package:flutter/material.dart';
import 'content_classes.dart';
import 'package:isar/isar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// TODO: Sync tiles with images, so both load at the same time
class CountryPage extends StatefulWidget {
  final Isar isar;
  final String countryName;
  final String countryDescription; // New parameter for country description

  const CountryPage({
    Key? key,
    required this.countryName,
    required this.isar,
    required this.countryDescription, // Initialize the new parameter
  }) : super(key: key);

  @override
  CountryPageState createState() => CountryPageState();
}

class CountryPageState extends State<CountryPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? 'Guest';
  late Future<List<City>> futureCities;
  List<String> favoriteBlogPosts = [];

  @override
  void initState() {
    super.initState();
    futureCities = fetchCities(widget.countryName);
    _loadInitialFavorites();
  }

  Future<void> _loadInitialFavorites() async {
    var userFavorites = await widget.isar.userFavorites
        .filter()
        .userIdEqualTo(FirebaseAuth.instance.currentUser?.uid ?? 'Guest')
        .findFirst();
    setState(() {
      favoriteBlogPosts = userFavorites?.favBlogPosts.toList() ?? [];
    });
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
        body: SafeArea(
          child: FutureBuilder<List<City>>(
            future: futureCities,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 10), // Padding after the list
                    ),
                    SliverAppBar(
                      expandedHeight: 60.0,
                      floating: false,
                      pinned: false,
                      title: Text(widget.countryName),
                      automaticallyImplyLeading: false,
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 25.0),
                        child: Text(widget.countryDescription),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          City city = snapshot.data![index];
                          bool isFavorite =
                              favoriteBlogPosts.contains(city.name);

                          return Container(
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
                                          if (favoriteBlogPosts
                                              .contains(city.name)) {
                                            favoriteBlogPosts.remove(city.name);
                                          } else {
                                            favoriteBlogPosts.add(city.name);
                                          }
                                        });

                                        // Update the local cache and Firebase in the background
                                        updateIsarFavorites(
                                            city.name, !isFavorite);
                                      },
                                      child: Icon(
                                        Icons.favorite,
                                        color: isFavorite
                                            ? Colors.red
                                            : Colors.white,
                                        size:
                                            24.0, // You can adjust the size as needed
                                      ),
                                    )),
                              ],
                            ),
                          );
                        },
                        childCount: snapshot.data!.length,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 30), // Padding after the list
                    ),
                  ],
                );
              } else {
                return const Center(child: Text('No data found'));
              }
            },
          ),
        ),
      ),
    );
  }

  Future<Country> fetchCountryDescription(String countryName) async {
    // Fetch the country's description from Isar
    Country? countryEntry =
        await widget.isar.countrys.where().nameEqualTo(countryName).findFirst();
    if (countryEntry == null) {
      throw Exception('Failed to load country');
    }
    return countryEntry;
  }

  Future<List<City>> fetchCities(String countryName) async {
    List<City> cachedCities = await widget.isar.citys
        .filter()
        .countryNameEqualTo(countryName)
        .findAll();
    if (cachedCities.isNotEmpty) {
      return cachedCities;
    } else {
      throw Exception('Failed to load cities');
    }
  }

  Future<void> updateIsarFavorites(String cityName, bool remove) async {
    print('Updating favorites in Isar');
    final userFavorites = await widget.isar.userFavorites
        .where()
        .userIdEqualTo(auth.currentUser?.uid ?? 'Guest')
        .findFirst();
    // Convert the fixed-length list to a growable list
    List<String> favBlogPosts = userFavorites?.favBlogPosts.toList() ?? [];

    if (!remove) {
      print('Adding $cityName to favorites');
      favBlogPosts.add(cityName);
    } else {
      print('Removing $cityName from favorites');
      favBlogPosts.remove(cityName);
    }

    // Update the favorites in Isar
    await widget.isar.writeTxn(() async {
      await widget.isar.userFavorites.put(UserFavorites(
        userId: auth.currentUser?.uid ?? 'Guest',
        favBlogPosts: favBlogPosts,
      ));
    });
  }

  // Function to update the favorite city in Firestore
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
