import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'blog_content.dart';





class BlogPostProvider with ChangeNotifier {
  Map<String, BlogPost> _blogPosts = {};

  Map<String, BlogPost> get blogPosts => _blogPosts;



  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BlogPostProvider() {
    fetchBlogPosts();
  }

  Future<void> fetchBlogPosts() async {
    print("fetchBlogPosts-----------------------------------------------------------");
    var querySnapshot = await _firestore.collection('blogposts').get();
    var blogPosts = <String, BlogPost>{};
    
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      var blogPost = BlogPost(
        postId: doc.id,
        title: data['title'],
        summary: data['summary'],
        caption: data['caption'],
        imageUrl: data['imageUrl'],
        imageAttribution: data['imageAttribution'],
        content: data['content'],
        country: data['country'],
        city: data['city'],
        isLiked: data['isLiked'] ?? false,
      );
      blogPosts[doc.id] = blogPost;
    }
    
    _blogPosts = blogPosts;
    notifyListeners();
    saveBlogPostsToHive(blogPosts.values.toList());
    listenForUpdates();
  }

  Future<void> saveBlogPostsToHive(List<BlogPost> blogPosts) async {
    print("saveBlogPostsToHive----------------------------------------------------------");
    final box = await Hive.openBox('blogPosts');
    for (var blogPost in blogPosts) {
      await box.put(blogPost.postId, blogPost);
    }
    box.close();
  }

  Future<void> saveBlogPostToHive(BlogPost blogPost) async {
    final box = await Hive.openBox('blogPosts');
    await box.put(blogPost.postId, blogPost);
    box.close();
  }

  Future<void> deleteBlogPostFromHive(String postId) async {
    final box = await Hive.openBox('blogPosts');
    await box.delete(postId);
    box.close();
  }

  void createBlogPost(BlogPost blogPost) {
    _firestore.collection('blogposts').doc(blogPost.postId).set(blogPost.toJson()).then((_) {
      saveBlogPostToHive(blogPost);
      _blogPosts[blogPost.postId] = blogPost;
      notifyListeners();
    });
  }

  void deleteBlogPost(String postId) {
    _firestore.collection('blogposts').doc(postId).delete().then((_) {
      deleteBlogPostFromHive(postId);
      _blogPosts.remove(postId);
      notifyListeners();
    });
  }

  void listenForUpdates() {
    _firestore.collection('blogposts').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          final newBlogPost = blogPostFromFirestoreDoc(change.doc);
          saveBlogPostToHive(newBlogPost).then((_) {
            _blogPosts[newBlogPost.postId] = newBlogPost;
            notifyListeners();
          });
        } else if (change.type == DocumentChangeType.modified) {
          final updatedBlogPost = blogPostFromFirestoreDoc(change.doc);
          saveBlogPostToHive(updatedBlogPost).then((_) {
            _blogPosts[updatedBlogPost.postId] = updatedBlogPost;
            notifyListeners();
          });
        } else if (change.type == DocumentChangeType.removed) {
          deleteBlogPostFromHive(change.doc.id).then((_) {
            _blogPosts.remove(change.doc.id);
            notifyListeners();
          });
        }
      });
    });
  }

  BlogPost blogPostFromFirestoreDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BlogPost(
      postId: doc.id,
      title: data['title'],
      summary: data['summary'],
      caption: data['caption'],
      imageUrl: data['imageUrl'],
      imageAttribution: data['imageAttribution'],
      content: data['content'],
      country: data['country'],
      city: data['city'],
      isLiked: data['isLiked'] ?? false,
    );
  }
}

Future<Map<String, BlogPost>> loadBlogPostsFromHive() async {
  print("loadBlogPostsFromHive-------------------------------------------------------");
  final box = await Hive.openBox('blogPosts');
  return box.toMap().cast<String, BlogPost>();
}