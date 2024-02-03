import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'content_classes.dart';
import 'city_content_page.dart';
import 'package:logger/logger.dart';

class SearchPage extends StatefulWidget {
  final Isar isar;
  final Logger logger;

  const SearchPage({Key? key, required this.isar, required this.logger})
      : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<City>>? _searchResults;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchResults = fetchCities(_searchController.text);
    });
  }

  Future<List<City>> fetchCities(String searchTerm) async {
    if (searchTerm.isEmpty) {
      return [];
    }

    List<City> cachedCities = await widget.isar.citys
        .filter()
        .nameContains(searchTerm, caseSensitive: false)
        .findAll();

    if (cachedCities.isNotEmpty) {
      return cachedCities;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  suffixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<City>>(
                future: _searchResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    if (_searchController.text.isNotEmpty) {
                      return const Center(child: Text('No cities found'));
                    } else {
                      return const Center(child: Text('Search for a city'));
                    }
                  } else {
                    return ListView.separated(
                      itemCount: snapshot.data!.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox.shrink(),
                      itemBuilder: (context, index) {
                        City city = snapshot.data![index];
                        return ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 35.0, vertical: 0.0),
                          title: Text(city.name),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CityDetailsPage(
                                  cityName: city.name,
                                  isar: widget.isar,
                                  logger: widget.logger,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
