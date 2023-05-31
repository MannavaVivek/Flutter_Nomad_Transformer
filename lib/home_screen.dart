import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_travel_stories/blog_post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const countryNames = [
    'Austria',
    'Belgium',
    'CzechRepublic',
    'France',
    'Germany',
    'Hungary',
    'Italy',
    'Luxembourg',
    'Netherlands',
    'Slovakia',
  ];

  static const countryUrls = {
    'Austria': '/country/austria',
    'Belgium': '/country/belgium',
    'CzechRepublic': '/country/czechrepublic',
    'France': '/country/france',
    'Germany': '/country/germany',
    'Hungary': '/country/hungary',
    'Italy': '/country/italy',
    'Luxembourg': '/country/luxembourg',
    'Netherlands': '/country/netherlands',
    'Slovakia': '/country/slovakia',
  };

  static const List<String> recommendedPosts = ['1', '2', '3'];

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final ScrollController _exploreScrollController = ScrollController();
  final ScrollController _recommendedReadsScrollController =
      ScrollController();
  bool _showExploreLeftScrollButton = true;
  bool _showExploreRightScrollButton = true;
  bool _showRecommendedReadsLeftScrollButton = false;
  bool _showRecommendedReadsRightScrollButton = false;

  final TextEditingController _searchController = TextEditingController();
  bool _isExpanded = false;

  List<String> filteredPosts = [];

  @override
  void initState() {
    super.initState();
    _exploreScrollController.addListener(() {
      setState(() {
        _showExploreLeftScrollButton =
            _exploreScrollController.offset > 0;
        _showExploreRightScrollButton =
            _exploreScrollController.position.maxScrollExtent -
                    _exploreScrollController.offset >
                0;
      });
    });
    _recommendedReadsScrollController.addListener(() {
      setState(() {
        _showRecommendedReadsLeftScrollButton =
            _recommendedReadsScrollController.offset > 0;
        _showRecommendedReadsRightScrollButton =
            _recommendedReadsScrollController.position.maxScrollExtent -
                    _recommendedReadsScrollController.offset >
                0;
      });
    });
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => calculateIfScrollButtonsNeeded(context));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _exploreScrollController.dispose();
    _recommendedReadsScrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    calculateIfScrollButtonsNeeded(context);
  }

  void calculateIfScrollButtonsNeeded(BuildContext context) {
    final recommendedReadsTotalItemWidth =
        HomeScreen.recommendedPosts.length * 350.0;
    final recommendedReadsScreenWidth = MediaQuery.of(context).size.width;

    setState(() {
      _showExploreLeftScrollButton = true;
      _showExploreRightScrollButton = true;
      _showRecommendedReadsLeftScrollButton =
          recommendedReadsTotalItemWidth > recommendedReadsScreenWidth;
      _showRecommendedReadsRightScrollButton =
          recommendedReadsTotalItemWidth > recommendedReadsScreenWidth;
    });
  }

  void _scrollExploreLeft() {
    _exploreScrollController.animateTo(
      _exploreScrollController.offset - 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollExploreRight() {
    _exploreScrollController.animateTo(
      _exploreScrollController.offset + 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRecommendedReadsLeft() {
    _recommendedReadsScrollController.animateTo(
      _recommendedReadsScrollController.offset - 400,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRecommendedReadsRight() {
    _recommendedReadsScrollController.animateTo(
      _recommendedReadsScrollController.offset + 400,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
        leading: _isExpanded
            ? null
            : IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  context.go('/');
                },
              ),
        title: _isExpanded
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search...',
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(width: 0, style: BorderStyle.none),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      filteredPosts = blogPosts.values
                          .where((post) =>
                              post.city.toLowerCase().contains(value.toLowerCase()))
                          .map((post) => post.postId)
                          .toList();
                    } else {
                      filteredPosts = [];
                    }
                  });
                },
              )
            : Text('Wanderlust'),
        actions: [
          IconButton(
            icon: Icon(_isExpanded ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
                if (!_isExpanded) {
                  _searchController.clear();
                  filteredPosts = []; // Clear the filtered posts
                }
              });
            },
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.center,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 900),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Explore',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Courgette',
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _exploreScrollController,
                          child: Row(
                            children: HomeScreen.countryNames
                                .map((country) {
                                  return GestureDetector(
                                    onTap: () {
                                      final countryUrl =
                                          HomeScreen.countryUrls[country];
                                      if (countryUrl != null) {
                                        context.go(countryUrl);
                                      }
                                    },
                                    child: Container(
                                      width: 120,
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/${country.toLowerCase()}_unsplash.jpg',
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            country,
                                            style: TextStyle(fontFamily: 'Nunito'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                                .toList(),
                          ),
                        ),
                        if (_showExploreLeftScrollButton)
                          Positioned(
                            top: -20,
                            bottom: 0,
                            left: 0,
                            child: AnimatedOpacity(
                              opacity: _showExploreLeftScrollButton ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: _showExploreLeftScrollButton ? 40.0 : 0.0,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: _scrollExploreLeft,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (_showExploreRightScrollButton)
                          Positioned(
                            top: -20,
                            bottom: 0,
                            right: 0,
                            child: AnimatedOpacity(
                              opacity: _showExploreRightScrollButton ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: _showExploreRightScrollButton ? 40.0 : 0.0,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: _scrollExploreRight,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _isExpanded ? 'Search Results:' : 'Recommended Reads',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Courgette',
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _recommendedReadsScrollController,
                          child: Row(
                            children: filteredPosts.isNotEmpty
                                ? filteredPosts.map((postId) {
                                    final BlogPost post = blogPosts[postId]!;
                                    return Container(
                                      width: 300,
                                      height: 300,
                                      child: BlogPostListItem(
                                        postId: post.postId,
                                        title: post.title,
                                        summary: post.summary,
                                        caption: post.caption,
                                        imageUrl: post.imageUrl,
                                        imageAttribution: post.imageAttribution,
                                        country: post.country,
                                        city: post.city,
                                      ),
                                    );
                                  }).toList()
                                : (_isExpanded
                                    ? []
                                    : HomeScreen.recommendedPosts.map((postId) {
                                        final BlogPost post = blogPosts[postId]!;
                                        return Container(
                                          width: 300,
                                          height: 300,
                                          child: BlogPostListItem(
                                            postId: post.postId,
                                            title: post.title,
                                            summary: post.summary,
                                            caption: post.caption,
                                            imageUrl: post.imageUrl,
                                            imageAttribution: post.imageAttribution,
                                            country: post.country,
                                            city: post.city,
                                          ),
                                        );
                                      }).toList()),
                          ),
                        ),
                        if (_showRecommendedReadsLeftScrollButton ||
                                _showRecommendedReadsRightScrollButton ||
                            filteredPosts.length > 3)
                          Positioned(
                            top: -20,
                            bottom: 0,
                            left: 0,
                            child: AnimatedOpacity(
                              opacity:
                                  _showRecommendedReadsLeftScrollButton ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: _showRecommendedReadsLeftScrollButton
                                    ? 40.0
                                    : 0.0,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: _scrollRecommendedReadsLeft,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (_showRecommendedReadsLeftScrollButton ||
                                _showRecommendedReadsRightScrollButton ||
                            filteredPosts.length > 3)
                          Positioned(
                            top: -20,
                            bottom: 0,
                            right: 0,
                            child: AnimatedOpacity(
                              opacity:
                                  _showRecommendedReadsRightScrollButton ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: _showRecommendedReadsRightScrollButton
                                    ? 40.0
                                    : 0.0,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: _scrollRecommendedReadsRight,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
