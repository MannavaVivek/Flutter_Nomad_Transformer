import 'package:flutter/material.dart'; // Update with your project path
import 'package:http/http.dart' as http;
import 'dart:convert';

class City {
  final String name;
  final String description;
  final String imageAssetID;
  final String imageAssetURL;

  City({
    required this.name,
    required this.description,
    required this.imageAssetID,
    required this.imageAssetURL,
  });

  factory City.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> includes) {
    // Similar implementation as Country.fromJson
    final fields = json['fields'];

    final matchingAsset = includes['Asset'].firstWhere(
      (asset) => asset['sys']['id'] == json['fields']['cityPhoto']['sys']['id'],
      orElse: () => null,
    );

    String imageUrl = "";
    if (matchingAsset != null) {
      imageUrl = matchingAsset['fields']['file']['url'];
      print('Image URL: $imageUrl');
    } else {
      print('No matching asset found');
    }

    if (fields['cityName'] == null) {
      fields['cityName'] = 'No city name';
    } else if (fields['cityDescription'] == null) {
      fields['cityDescription'] = 'No city description';
    } else if (fields['cityPhoto'] == null) {
      fields['cityPhoto'] = 'No city photo';
    }

    return City(
      name: fields['cityName'],
      description: fields['cityDescription'],
      imageAssetID: fields['cityPhoto']['sys']['id'],
      imageAssetURL: imageUrl,
    );
  }
}

class CountryPage extends StatefulWidget {
  final String countryName;

  CountryPage({Key? key, required this.countryName}) : super(key: key);

  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  late Future<List<City>> futureCities;

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
            return GridView.builder(
              itemCount: snapshot.data?.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                City city = snapshot.data![index];
                return GridTile(
                  footer: GridTileBar(
                    backgroundColor: Colors.black45,
                    title: Text(city.name),
                  ),
                  child: Image.network(
                    'https:${city.imageAssetURL}',
                    fit: BoxFit.cover,
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

  Future<List<City>> fetchCities(String countryName) async {
    // Fetch cities from Contentful
    // Same structure as fetchCountries but change the contentType
    // Use Country class method to get the ContentType for cities

    const String spaceID = 'pqzjijb5vjqz';
    const String accessToken = 'IVqE-SRtoM5IZ8bTHuf0Cwnx3Jb470uML77gX-2mYwQ';
    const String environment = 'master';
    // contentType is the lowercase of countryname, 'city'
    countryName = countryName.toLowerCase();
    String contentType = '$countryName,city';
    print(contentType);
    try {
      final response = await http.get(
        Uri.parse(
          'https://cdn.contentful.com/spaces/$spaceID/environments/$environment/entries?access_token=$accessToken&metadata.tags.sys.id[all]=$contentType',
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final includes = jsonResponse['includes'];

        List<dynamic> body = jsonResponse['items'];
        return body
            .map((dynamic item) => City.fromJson(item, includes))
            .toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
