import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'hive_service.dart';

class UserProvider with ChangeNotifier {
  String? _userId = '';

  String? get userId => _userId;

  UserProvider() {
    _loadUserId();
  }
  
  _loadUserId() async {
    await HiveService.initHive();
    
    // Load the userId from Hive
    _userId = HiveService.getUserId();
    print("=====================================================================");
    print("Initial loading from the Hive box: $_userId");
    print("=====================================================================");
    notifyListeners();
  }

  void setUser(String? userId) async {
    _userId = userId;
    print("=====================================================================");
    print("UserProvider.setUser: $userId");
    print("=====================================================================");
    // Save the new userId to Hive
    HiveService.setUserId(userId);
    HiveService.setUsername('Guest');
    HiveService.setQuote("Do I wake up every morning and ask you for Coffee Coffee Cream Cream?");
    HiveService.setLikedPosts([]);
    notifyListeners();
  }
}
