import 'package:hive/hive.dart';

part 'blog_content.g.dart';

@HiveType(typeId: 0)
class BlogPost extends HiveObject {
  @HiveField(0)
  final String postId;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String summary;
  @HiveField(3)
  final String caption;
  @HiveField(4)
  final String imageUrl;
  @HiveField(5)
  final String imageAttribution;
  @HiveField(6)
  final String content;
  @HiveField(7)
  final String country;
  @HiveField(8)
  final String city;
  @HiveField(9)
  final bool isLiked;

  BlogPost({
    required this.postId,
    required this.title,
    required this.summary,
    required this.caption,
    required this.imageUrl,
    required this.imageAttribution,
    required this.content,
    required this.country,
    required this.city,
    this.isLiked = false,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'summary': summary,
    'caption': caption,
    'imageUrl': imageUrl,
    'imageAttribution': imageAttribution,
    'content': content,
    'country': country,
    'city': city,
    'isLiked': isLiked,
  };
}
