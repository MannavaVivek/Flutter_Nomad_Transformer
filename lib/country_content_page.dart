import 'package:flutter/material.dart';
import 'content_classes.dart';
import 'package:isar/isar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CountryPage extends StatefulWidget {
  final Isar isar;
  final String countryName;
  final String countryDescription; // New parameter for country description

  CountryPage({
    Key? key,
    required this.countryName,
    required this.isar,
    required this.countryDescription, // Initialize the new parameter
  }) : super(key: key);

  @override
  CountryPageState createState() => CountryPageState();
}

class CountryPageState extends State<CountryPage> {
  late Future<List<City>> futureCities;
  Map<String, bool> favoriteCities = {}; // Track favorite cities

  @override
  void initState() {
    super.initState();
    futureCities = fetchCities(widget.countryName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.countryName)),
      body: FutureBuilder<List<City>>(
        future: futureCities,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget
                      .countryDescription), // Display the passed country description
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      City city = snapshot.data![index];
                      bool isFavorite = favoriteCities[city.name] ?? false;
                      return Container(
                        margin: const EdgeInsets.all(10),
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
                                          Colors
                                              .transparent, // Top of the gradient is transparent
                                          Colors
                                              .grey, // Bottom of the gradient is white
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
                              top: 130, // Position where image and text meet
                              right: 15,
                              child: FloatingActionButton(
                                mini: true,
                                shape: const CircleBorder(),
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.favorite,
                                  color: isFavorite ? Colors.red : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    favoriteCities[city.name] = !isFavorite;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          }
          return const Center(child: Text('No data found'));
        },
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
}
