import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Country {
  final String name;
  final String description;
  final String imageUrl;

  Country(
      {required this.name, required this.description, required this.imageUrl});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['fields']['country_name'],
      description: json['fields']['country_description'],
      imageUrl: json['fields']['country_photo']['fields']['file']['url'],
    );
  }
}

Future<List<Country>> fetchCountries() async {
  const String spaceId = 'pqzjijb5vjqz';
  const String accessToken = 'IVqE-SRtoM5IZ8bTHuf0Cwnx3Jb470uML77gX-2mYwQ';
  const String environment = 'master';
  const String contentType = 'country';

  final response = await http.get(
    Uri.parse(
        'https://cdn.contentful.com/spaces/$spaceId/environments/$environment/entries?access_token=$accessToken&content_type=$contentType'),
  );

  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body)['items'];
    return body.map((dynamic item) => Country.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load countries from Contentful');
  }
}
