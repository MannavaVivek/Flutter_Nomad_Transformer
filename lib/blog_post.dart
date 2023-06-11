import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'blog_content.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'food_rec.dart';
import 'hive_service.dart';
import 'user_provider.dart';
import 'package:provider/provider.dart';
import 'blogpost_provider.dart';

class BlogPostListItemCountry extends StatelessWidget {
  final String postId;
  final String title;
  final String summary;
  final String caption;
  final String imageUrl;
  final String imageAttribution;
  final String country;
  final String city;
  final bool isLiked; // New parameter for tracking if the post is liked

  const BlogPostListItemCountry({
    Key? key,
    required this.postId,
    required this.title,
    required this.summary,
    required this.caption,
    required this.imageUrl,
    required this.imageAttribution,
    required this.country,
    required this.city,
    this.isLiked = false, // Include the new parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.white,
                    size: 24,
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
    );
  }
}



class BlogPostListItemHome extends StatelessWidget {
  final String postId;
  final String title;
  final String summary;
  final String caption;
  final String imageUrl;
  final String imageAttribution;
  final String country;
  final String city;
  final bool isLiked; // New parameter for tracking if the post is liked

  const BlogPostListItemHome({
    Key? key,
    required this.postId,
    required this.title,
    required this.summary,
    required this.caption,
    required this.imageUrl,
    required this.imageAttribution,
    required this.country,
    required this.city,
    this.isLiked = false, // Include the new parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/post/$postId'),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          height: 200,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.white,
                  size: 24,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
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
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        summary,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Nunito',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
  late PageController _pageController;
  int _currentPageIndex = 0;
  bool _isLiked = false;
  final List<String> likedPostIds = HiveService.getLikedPosts();
  final String userId = HiveService.getUserId();

  @override
  void initState() {
    super.initState();
    // final blogPostProvider = Provider.of<BlogPostProvider>(context);
    // final blogPosts = blogPostProvider.blogPosts;
    // _post = blogPosts[widget.postId]!;
    _scrollController = ScrollController();
    _pageController = PageController();
    // connect to the hive class
    _checkLikedStatus(); // Check if the post is liked by the user
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final blogPostProvider = Provider.of<BlogPostProvider>(context);
    final blogPosts = blogPostProvider.blogPosts;
    _post = blogPosts[widget.postId]!;
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
    _pageController.dispose();
    super.dispose();
  }

  void _checkLikedStatus() {
    _isLiked = likedPostIds.contains(widget.postId); // Check if the current post ID is in the liked posts
  }

  void _toggleLikedStatus() async{

  if (userId.isEmpty) {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You must be logged in to like posts'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    context.push('/user');
  } else {
    setState(() {
      _isLiked = !_isLiked;
    });
    // update the liked posts list using provider
    Provider.of<UserProvider>(context, listen: false).setLikedStatus(widget.postId, _isLiked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/transparent_logo.png',
              width: 300,
              height: 150,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity! > 0) {
            // Swiped from left to right (right to left swipe)
            if (_currentPageIndex > 0) {
              _pageController.previousPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          } else if (details.primaryVelocity! < 0) {
            // Swiped from right to left (left to right swipe)
            if (_currentPageIndex < 1) {
              _pageController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        MouseRegion(
                          onEnter: (_) => setState(() => _isHovered = true),
                          onExit: (_) => setState(() => _isHovered = false),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: _post.imageUrl,
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
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
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
                  FoodRecommendationScreen(postId: widget.postId),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor:
                        _currentPageIndex == 0 ? Colors.blue : Colors.grey,
                  ),
                  SizedBox(width: 4),
                  CircleAvatar(
                    radius: 4,
                    backgroundColor:
                        _currentPageIndex == 1 ? Colors.blue : Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  context.push('/');
                });
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 34,
                    width: 34,
                    child: RiveAnimation.asset(
                      'assets/RiveAssets/icons.riv',
                      artboard: "HOME",
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                context.push('/search');
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 34,
                    width: 34,
                    child: RiveAnimation.asset(
                      'assets/RiveAssets/icons.riv',
                      artboard: "SEARCH",
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  context.push('/favorites');
                });
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 34,
                    width: 34,
                    child: RiveAnimation.asset(
                      'assets/RiveAssets/icons.riv',
                      artboard: "LIKE/STAR",
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  context.push('/user');
                });
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 34,
                    width: 34,
                    child: RiveAnimation.asset(
                      'assets/RiveAssets/icons.riv',
                      artboard: "USER",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toggleLikedStatus(); // Toggle the liked status
          if(userId.isNotEmpty) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(_isLiked ? 'Liked' : 'Removed from Favorites'),
                  content: Text(
                    _isLiked
                        ? 'You have liked this post.'
                        : 'You have removed this post from favorites.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          };
        },
        child: Icon(
          _isLiked ? Icons.favorite : Icons.favorite_border,
          color: _isLiked ? Colors.red : Colors.white,
        ),
      ),
    );
  }
}
