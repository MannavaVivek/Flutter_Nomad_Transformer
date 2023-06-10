import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'hive_service.dart';

class UserProvider with ChangeNotifier {
  String? _avatarUrl;

  ValueNotifier<String?> _userId = ValueNotifier<String?>(null);
  String? get userId => _userId.value;
  String? get avatarUrl => _avatarUrl;

  UserProvider() {
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    await HiveService.initHive();

    try {
      final userId = HiveService.getUserId();
      _userId.value = userId;
    } catch (e) {
      print("Error loading userId from Hive: $e");
    }

    notifyListeners();
  }

  Future<void> setUser(String? userId) async {
    _userId.value = userId;

    try {
      HiveService.setUserId(userId);
      HiveService.setUsername('Guest');
      HiveService.setQuote("Do I wake up every morning and ask you for Coffee Coffee Cream Cream?");
      HiveService.setLikedPosts([]);
      HiveService.setAvatar('https://firebasestorage.googleapis.com/v0/b/nomad-transformer.appspot.com/o/icons%2Frobot_default_profile_pic.jpg?alt=media&token=35f06ede-afaf-4027-9937-69a0760a7f1e');
    } catch (e) {
      print("Error saving userId to Hive: $e");
    }
    notifyListeners();
  }

  void setAvatar(String url) {
      _avatarUrl = url;
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
