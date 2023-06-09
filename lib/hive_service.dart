import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Box<String>? _box;
  static const String _avatarKey = 'avatarKey';

  static Future<void> initHive() async {
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox<String>('appBox');

      // Set default values if not already set
      if (_box!.get('username') == null) {
        _box!.put('username', 'Guest');
      }
      if (_box!.get('userid') == null) {
        _box!.put('userid', '');
      }
      if (_box!.get('quote') == null) {
        _box!.put('quote', "Do I wake up every morning and ask you for Coffee Coffee Cream Cream?");
      }

      if (_box!.get('liked_posts') == null) {
        final defaultLikedPosts = <String>[];
        final likedPostsJson = defaultLikedPosts.join(',');
        _box!.put('liked_posts', likedPostsJson);
      }
    } catch (e) {
      // Handle initialization errors
      print('Hive initialization failed: $e');
    }
  }

  // Getters
  static String getUsername() {
    print("Called getUsername");
    return _box!.get('username') ?? 'Guest';
  }

  static String getUserId() {
    print("Called getUserId");
    return _box!.get('userid') ?? '';
  }

  static String getQuote() {
    print("Called getQuote");
    return _box!.get('quote') ?? "Do I wake up every morning and ask you for Coffee Coffee Cream Cream?";
  }

  static List<String> getLikedPosts() {
    print("Called getLikedPosts");
    final likedPostsJson = _box!.get('liked_posts');
    if (likedPostsJson != null) {
      final likedPosts = likedPostsJson.split(',');
      return likedPosts;
    } else {
      return [];
    }
  }

  static String getAvatar() {
    print("Called getAvatar");
    return _box!.get(_avatarKey) ?? 'https://firebasestorage.googleapis.com/v0/b/nomad-transformer.appspot.com/o/icons%2Frobot_default_profile_pic.jpg?alt=media&token=35f06ede-afaf-4027-9937-69a0760a7f1e';
  }



  // Setters
  static void setUsername(String username) {
    print("Called setUsername with $username");
    _box!.put('username', username);
  }

  static void setUserId(String? userId) {
    print("Called setUserId with $userId");

    _box!.put('userid', userId ?? '');
  }

  static void setQuote(String quote) {
    print("Called setQuote with $quote");
    _box!.put('quote', quote);
  }

  static void setLikedPosts(List<String> likedPosts) {
    print("Called setLikedPosts with $likedPosts");
    final likedPostsJson = likedPosts.join(',');
    _box!.put('liked_posts', likedPostsJson);
  }

  static void setAvatar(String url) {
    print("Called setAvatar with url");
    _box!.put(_avatarKey, url);
  }



  // Other
  static Box<String>? get box => _box;
}
