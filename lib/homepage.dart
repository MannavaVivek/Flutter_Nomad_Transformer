import 'package:flutter/material.dart';
import 'country_content_page.dart';
import 'content_classes.dart';
import 'package:isar/isar.dart';
import 'package:cached_network_image/cached_network_image.dart';

// HomePage widget
class HomePage extends StatefulWidget {
  final Isar isar;

  HomePage({Key? key, required this.isar}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Country>> futureCountries;
  List<Country> countriesList = [];

  @override
  void initState() {
    super.initState();
    futureCountries = fetchCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: FutureBuilder<List<Country>>(
        future: futureCountries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15), // Horizontal padding
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var country in snapshot.data!)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CountryPage(
                                  countryName: country.name,
                                  isar: widget.isar,
                                  countryDescription: country.description),
                            ),
                          );
                        },
                        child: Container(
                          width: 150, // Adjust width to 150px
                          margin: const EdgeInsets.only(
                              right: 10), // Spacing between tiles
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: 'https:${country.imageAssetURL}',
                                  width: 150, // Adjust width to 150px
                                  height: 150, // Adjust height to 150px
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Icon(Icons.error),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  height: 10), // Spacing between image and text
                              Text(
                                country.name,
                                style: const TextStyle(
                                    fontFamily:
                                        'Nunito'), // Adjust text style as needed
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text('No data found'));
        },
      ),
    );
  }

  // Function to fetch countries from Contentful
  Future<List<Country>> fetchCountries() async {
    List<Country> cachedCountries =
        await widget.isar.countrys.where().limit(200).findAll();
    if (cachedCountries.isNotEmpty) {
      print(cachedCountries.length);
      return cachedCountries;
    } else {
      throw Exception('Failed to load countries');
    }
  }
}
