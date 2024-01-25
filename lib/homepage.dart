import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'country_content_page.dart';
import 'content_classes.dart';
import 'package:isar/isar.dart';

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
            return GridView.builder(
              itemCount: snapshot.data?.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                Country country = snapshot.data![index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CountryPage(countryName: country.name),
                      ),
                    );
                  },
                  child: GridTile(
                    footer: GridTileBar(
                      backgroundColor: Colors.black45,
                      title: Text(country.name),
                    ),
                    child: Image.network(
                      'https:${country.imageAssetURL}',
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No data found'));
        },
      ),
    );
  }

  void _showCountryDescription(BuildContext context, String description) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Country Description'),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchAndStoreCountries() async {
    try {
      final countries = await futureCountries;
      countriesList.addAll(countries); // Add fetched countries to the list
    } catch (e) {
      print('Error fetching and storing countries: $e');
    }
  }

  void _loadCountries() {
    if (countriesList.isEmpty) {
      _fetchAndStoreCountries();
    }
  }

  // Function to fetch countries from Contentful
  Future<List<Country>> fetchCountries() async {
    const String spaceId = 'pqzjijb5vjqz';
    const String accessToken = 'IVqE-SRtoM5IZ8bTHuf0Cwnx3Jb470uML77gX-2mYwQ';
    const String environment = 'master';
    const String contentType = 'country';

    final response = await http.get(
      Uri.parse(
        'https://cdn.contentful.com/spaces/$spaceId/environments/$environment/entries?access_token=$accessToken&metadata.tags.sys.id[all]=$contentType',
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final includes = jsonResponse['includes'];

      List<dynamic> body = jsonResponse['items'];
      return body
          .map((dynamic item) => Country.fromJson(item, includes))
          .toList();
    } else {
      print('Failed to load countries from Contentful: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load countries from Contentful');
    }
  }
}
