import 'package:flutter/material.dart';
import 'content_classes.dart';
import 'package:isar/isar.dart';

class CountryPage extends StatefulWidget {
  final Isar isar;
  final String countryName;

  CountryPage({Key? key, required this.countryName, required this.isar})
      : super(key: key);

  @override
  CountryPageState createState() => CountryPageState();
}

class CountryPageState extends State<CountryPage> {
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
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.purple),
                        ),
                      );
                    },
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
