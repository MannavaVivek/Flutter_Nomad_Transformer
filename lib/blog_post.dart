import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'blog_content.dart';

List<BlogPost> getBlogPostsForCountry(String country) {
  return blogPosts.values.where((post) => post.country.toLowerCase() == country.toLowerCase()).toList();
}


class BlogPostListItem extends StatelessWidget {
  final String postId;
  final String title;
  final String summary;
  final String caption;
  final String imageUrl;
  final String imageAttribution;
  final String country;
  final String city;

  const BlogPostListItem({
    Key? key,
    required this.postId,
    required this.title,
    required this.summary,
    required this.caption,
    required this.imageUrl,
    required this.imageAttribution,
    required this.country,
    required this.city,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/post/$postId'),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.asset(
                imageUrl,
                width: double.infinity,
                height: 180, // Adjust the height as needed
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      fontFamily: 'Courgette',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    summary,
                    style: TextStyle(
                      fontSize: 12, 
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class BlogPostScreen extends StatefulWidget {
  final String postId;

  const BlogPostScreen({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  _BlogPostScreenState createState() => _BlogPostScreenState();
}


class _BlogPostScreenState extends State<BlogPostScreen> {
  late BlogPost _post;
  bool _isHovered = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _post = blogPosts[widget.postId]!;
    
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Wait for the widget rendering to complete and then scroll
    if (MediaQuery.of(context).size.height > 800) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          _scrollController.jumpTo(1100);
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.deepPurple],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      leading: Tooltip(
        message: 'Back',
        child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
          },
        ),
      ),
      title: Text(
        "Explore ${_post.city}",
        style: TextStyle(fontFamily: 'Courgette'),
      ),
    ),
    body: SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: Stack(
              children: [
                Image.asset(
                  _post.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                if (_isHovered)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.black.withOpacity(0.5),
                      child: Text(
                        _post.imageAttribution,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _post.title,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  _post.content,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

}
