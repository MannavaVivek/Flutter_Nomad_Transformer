import 'package:isar/isar.dart';

part 'content_classes.g.dart';

@Collection()
class Country {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String name;
  final String description;
  final String imageAssetID;
  final String imageAssetURL;

  Country({
    required this.name,
    required this.description,
    required this.imageAssetID,
    required this.imageAssetURL,
  });

  factory Country.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> includes) {
    final fields = json['fields'];

    // Find the asset in the includes.assets list with matching sys.id
    final matchingAsset = includes['Asset'].firstWhere(
      (asset) =>
          asset['sys']['id'] == json['fields']['countryPhoto']['sys']['id'],
      orElse: () => null,
    );

    String imageUrl = "";

    if (matchingAsset != null) {
      imageUrl = matchingAsset['fields']['file']['url'];
      print('Image URL: $imageUrl');
    } else {
      print('No matching asset found');
    }

    return Country(
      name: fields['countryName'],
      description: fields['countryDescription'],
      imageAssetID: fields['countryPhoto']['sys']['id'],
      imageAssetURL: imageUrl,
    );
  }
}

@Collection()
class City {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String name;

  final String countryName;
  final String description;
  final String imageAssetID;
  final String imageAssetURL;

  City({
    required this.name,
    required this.countryName,
    required this.description,
    required this.imageAssetID,
    required this.imageAssetURL,
  });

  factory City.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> includes) {
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
    } else if (fields['countryName'] == null) {
      fields['countryName'] = 'No country name';
    } else if (fields['cityDescription'] == null) {
      fields['cityDescription'] = 'No city description';
    } else if (fields['cityPhoto'] == null) {
      fields['cityPhoto'] = 'No city photo';
    }

    return City(
      name: fields['cityName'],
      countryName: fields['countryName'],
      description: fields['cityDescription'],
      imageAssetID: fields['cityPhoto']['sys']['id'],
      imageAssetURL: imageUrl,
    );
  }
}

@Collection()
class Recommendation {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String recommendedCity;

  final String tagline;

  @Index()
  final String tag;

  Recommendation({
    required this.recommendedCity,
    required this.tagline,
    required this.tag,
  });

  // Define the fromJson method
  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      recommendedCity: json['recommendedCity'] as String? ?? 'Unknown City',
      tagline: json['tagline'] as String? ?? 'No tagline available',
      tag: json['tag'] as String? ?? 'recommendedEntries',
    );
  }

  // Method to create a list of Recommendation objects from API response
  static List<Recommendation> fromApiResponse(
      Map<String, dynamic> apiResponse) {
    List<Recommendation> recommendations = [];

    var items = apiResponse['items'] as List;
    if (items.isNotEmpty) {
      var fields = items.first['fields'];
      var recommendedCities = fields['recommendedCities'] as Map;

      recommendedCities.forEach((city, tagline) {
        recommendations.add(Recommendation(
            recommendedCity: city,
            tagline: tagline,
            tag: 'recommendedEntries'));
      });
    } else {
      throw Exception('Failed to load recommendations');
    }

    return recommendations;
  }
}
