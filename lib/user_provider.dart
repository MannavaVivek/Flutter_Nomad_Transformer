import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String _userId = '';

  String get userId => _userId;

  void setUser(String userId) {
    _userId = userId;
    notifyListeners();
  }
}
