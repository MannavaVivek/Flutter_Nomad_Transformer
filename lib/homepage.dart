import 'package:flutter/material.dart';
import 'country_content_page.dart';
import 'content_classes.dart';
import 'package:isar/isar.dart';
import 'package:cached_network_image/cached_network_image.dart';

// HomePage widget
class HomePage extends StatefulWidget {
  final Isar isar;

  const HomePage({Key? key, required this.isar}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Future<List<Country>> futureCountries;
  late Future<List<Recommendation>> futureRecommendations;

  @override
  void initState() {
    super.initState();
    futureCountries = fetchCountries();
    futureRecommendations = fetchRecommendations();
  }

  Future<List<Country>> fetchCountries() async {
    List<Country> cachedCountries =
        await widget.isar.countrys.where().limit(200).findAll();
    if (cachedCountries.isNotEmpty) {
      return cachedCountries;
    } else {
      throw Exception('Failed to load countries');
    }
  }

  Future<List<Recommendation>> fetchRecommendations() async {
    List<Recommendation> cachedRecommendations =
        await widget.isar.recommendations.where().findAll();
    if (cachedRecommendations.isNotEmpty) {
      return cachedRecommendations;
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  Future<List<City>> fetchCities(String recommendedCity) async {
    List<City> cachedCities =
        await widget.isar.citys.filter().nameEqualTo(recommendedCity).findAll();
    if (cachedCities.isNotEmpty) {
      return cachedCities;
    } else {
      throw Exception('Failed to load cities');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            floating: false,
            pinned: false,
            title: Text("World Travel Guide"),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<List<Country>>(
              future: futureCountries,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return buildCountrySection(snapshot.data!);
                } else {
                  return const Center(child: Text('No countries found'));
                }
              },
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Recommended Reads",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<List<Recommendation>>(
              future: futureRecommendations,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return buildRecommendationSection(snapshot.data!);
                } else {
                  return const Center(child: Text('No recommendations found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCountrySection(List<Country> countries) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            countries.map((country) => buildCountryTile(country)).toList(),
      ),
    );
  }

  Widget buildCountryTile(Country country) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CountryPage(
              countryName: country.name,
              isar: widget.isar,
              countryDescription: country.description,
            ),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: 'https:${country.imageAssetURL}',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              country.name,
              style: const TextStyle(fontFamily: 'Nunito'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRecommendationSection(List<Recommendation> recommendations) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            recommendations.map((rec) => buildRecommendationTile(rec)).toList(),
      ),
    );
  }

  Widget buildRecommendationTile(Recommendation recommendation) {
    return FutureBuilder<List<City>>(
      future: fetchCities(recommendation.recommendedCity),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return Container(
            width: double.infinity,
            height: 150,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(child: Text('No image available')),
          );
        }

        City city = snapshot.data!.first;
        return Container(
          width: double.infinity,
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: CachedNetworkImageProvider('https:${city.imageAssetURL}'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      recommendation.recommendedCity,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      recommendation.tagline,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
