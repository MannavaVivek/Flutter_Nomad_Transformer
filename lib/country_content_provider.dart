import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CountryProvider {
  static const String boxName = 'countriesBox';
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> syncDataFromFirestore() async {
    final box = await Hive.openBox(boxName);

    QuerySnapshot snapshot = await _firestore.collection('countries').get();

    for (var doc in snapshot.docs) {
      box.put(doc.id, doc.data());
    }
  }

  static dynamic getCountryData(String countryName) {
    final box = Hive.box(boxName);

    if (box.containsKey(countryName)) {
      return box.get(countryName);
    }
    return null;
  }
}
