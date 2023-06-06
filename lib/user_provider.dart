import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'hive_service.dart';

class UserProvider with ChangeNotifier {
  ValueNotifier<String?> _userId = ValueNotifier<String?>(null);
  String? get userId => _userId.value;

  UserProvider() {
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    await HiveService.initHive();

    try {
      final userId = HiveService.getUserId();
      _userId.value = userId;
      print("=====================================================================");
      print("Initial loading from the Hive box: $userId");
      print("=====================================================================");
    } catch (e) {
      print("Error loading userId from Hive: $e");
    }

    notifyListeners();
  }

  Future<void> setUser(String? userId) async {
    _userId.value = userId;
    print("=====================================================================");
    print("UserProvider.setUser: $userId");
    print("=====================================================================");

    try {
      HiveService.setUserId(userId);
      HiveService.setUsername('Guest');
      HiveService.setQuote("Do I wake up every morning and ask you for Coffee Coffee Cream Cream?");
      HiveService.setLikedPosts([]);
    } catch (e) {
      print("Error saving userId to Hive: $e");
    }

    notifyListeners();
  }

  Future<void> setLikedStatus(String postId, bool isLiked) async {
    final likedPostIds = await HiveService.getLikedPosts();

    if (isLiked) {
      likedPostIds.add(postId); // Add postId to likedPosts list
      await FirebaseFirestore.instance
          .collection('user_data_personal')
          .doc(userId)
          .collection('posts')
          .doc(postId)
          .set({});
    } else {
      likedPostIds.remove(postId); // Remove postId from likedPosts list
      await FirebaseFirestore.instance
          .collection('user_data_personal')
          .doc(userId)
          .collection('posts')
          .doc(postId)
          .delete();
    }

    HiveService.setLikedPosts(likedPostIds);
  }
}
