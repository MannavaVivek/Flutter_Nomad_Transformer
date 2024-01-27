import 'package:flutter/material.dart';
import 'content_classes.dart';
import 'package:isar/isar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//TODO: Update the Firebase cloudstore api to the latest version
class CityDetailsPage extends StatefulWidget {
  final String cityName;
  final Isar isar;

  const CityDetailsPage({
    Key? key,
    required this.cityName,
    required this.isar,
  }) : super(key: key);

  @override
  _CityDetailsPageState createState() => _CityDetailsPageState();
}

class _CityDetailsPageState extends State<CityDetailsPage> {
  late Future<City?> futureCity;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    futureCity = fetchCity(widget.cityName);
  }

  Future<City?> fetchCity(String cityName) async {
    bool favstatus = await checkIfFavorite(cityName);
    setState(() {
      isFavorite = favstatus;
    });
    return widget.isar.citys
        .filter()
        .nameEqualTo(cityName, caseSensitive: false)
        .findFirst();
  }

  Future<bool> checkIfFavorite(String cityName) async {
    final userFavorites = await widget.isar.userFavorites
        .where()
        .userIdEqualTo(FirebaseAuth.instance.currentUser?.uid ?? 'Guest')
        .findFirst();
    return userFavorites?.favBlogPosts.contains(cityName) ?? false;
  }

  void toggleFavorite(String cityName, bool isFavorite) async {
    final user = FirebaseAuth.instance.currentUser?.uid ?? 'Guest';
    final userFavorites =
        await widget.isar.userFavorites.where().userIdEqualTo(user).findFirst();

    if (userFavorites == null && isFavorite) {
      await widget.isar.writeTxn(() async {
        await widget.isar.userFavorites
            .put(UserFavorites(userId: user, favBlogPosts: [cityName]));
      });
    } else {
      List<String> favPosts = userFavorites?.favBlogPosts.toList() ?? [];
      if (isFavorite) {
        favPosts.add(cityName);
      } else {
        favPosts.remove(cityName);
      }
      await widget.isar.writeTxn(() async {
        await widget.isar.userFavorites
            .put(UserFavorites(userId: user, favBlogPosts: favPosts));
      });
    }
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
            child: FutureBuilder<City?>(
              future: futureCity,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return const Center(child: Text('City not found'));
                }
                City city = snapshot.data!;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CachedNetworkImage(
                        imageUrl: 'https:${city.imageAssetURL}',
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          city.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(city.description),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            splashColor: Colors.red,
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              toggleFavorite(widget.cityName, isFavorite);
            },
            backgroundColor: Colors.white,
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
          )),
    );
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
