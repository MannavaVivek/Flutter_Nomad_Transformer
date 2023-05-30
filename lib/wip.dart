import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BlogPost {
  final String title;
  final String content;

  const BlogPost({required this.title, required this.content});
}

class BlogPostListItemData {
  final String postId;
  final String title;
  final String summary;
  final String imageUrl;
  final String imageAttribution;

  const BlogPostListItemData({
    required this.postId,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.imageAttribution,
  });
}

final blogPosts = {
  '1': const BlogPost(
    title: 'Adventure in Italy: A Journey Through Wine Country',
    content: 'From the rolling vineyards of Tuscany to the historic cellars of Piedmont, '
        'join us on an unforgettable tour through the wine regions of Italy.',
  ),
  '2': const BlogPost(
    title: 'Discovering Paris: The City of Lights',
    content: 'Paris, a city known for its art, architecture, and cafe culture. '
        'Experience the grandeur of the Eiffel Tower, the charm of Montmartre, '
        'and the elegance of the Louvre on this comprehensive journey through the City of Lights.',
  ),
};

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'post/:id',
          builder: (context, state) => BlogPostScreen(postId: state.pathParameters['id']!),
        ),
      ],
    ),
  ],
);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const countryNames = [
    'Austria',
    'Belgium',
    'Czechoslovakia',
    'France',
    'Germany',
    'Hungary',
    'Luxembourg',
    'Netherlands',
    'Slovakia',
  ];

  static const List<BlogPostListItemData> recommendedReads = [
    BlogPostListItemData(
      postId: '1',
      title: 'Adventure in Italy',
      summary: 'A thrilling journey through wine country...',
      imageUrl:
          'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/italy_unsplash.jpg',
      imageAttribution: 'Photo by Chris Karidis on Unsplash',
    ),
    BlogPostListItemData(
      postId: '2',
      title: 'Discovering Paris',
      summary: 'The city of lights has so much to offer...',
      imageUrl:
          'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/paris_unsplash.jpg',
      imageAttribution: 'Photo by Mattia Righetti on Unsplash',
    ),
  ];

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _exploreScrollController = ScrollController();
  final ScrollController _recommendedReadsScrollController = ScrollController();
  bool _showExploreLeftScrollButton = false;
  bool _showExploreRightScrollButton = false;
  bool _showRecommendedReadsLeftScrollButton = false;
  bool _showRecommendedReadsRightScrollButton = false;

  @override
  void initState() {
    super.initState();
    _exploreScrollController.addListener(() {
      setState(() {
        _showExploreLeftScrollButton = _exploreScrollController.offset > 0;
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
    WidgetsBinding.instance!.addPostFrameCallback(
        (_) => calculateIfScrollButtonsNeeded(context));
  }

  void calculateIfScrollButtonsNeeded(BuildContext context) {
    final exploreTotalItemWidth = HomeScreen.countryNames.length * 116.0;
    final exploreScreenWidth = MediaQuery.of(context).size.width;
    final recommendedReadsTotalItemWidth =
        HomeScreen.recommendedReads.length * 350.0;
    final recommendedReadsScreenWidth = MediaQuery.of(context).size.width;

    setState(() {
      _showExploreLeftScrollButton =
          exploreTotalItemWidth > exploreScreenWidth;
      _showExploreRightScrollButton =
          exploreTotalItemWidth > exploreScreenWidth;
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
        title: const Text('Home Page'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final exploreScreenWidth = constraints.maxWidth;
          final exploreTotalItemWidth = HomeScreen.countryNames.length * 116.0;
          final showExploreScrollButtons =
              exploreTotalItemWidth > exploreScreenWidth;

          final recommendedReadsScreenWidth = constraints.maxWidth;
          final recommendedReadsTotalItemWidth =
              HomeScreen.recommendedReads.length * 350.0;
          final showRecommendedReadsScrollButtons =
              recommendedReadsTotalItemWidth > recommendedReadsScreenWidth;

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Explore',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _exploreScrollController,
                    child: Row(
                      children: HomeScreen.countryNames.map((country) {
                        return Container(
                          width: 120,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/${country.toLowerCase()}_unsplash.jpg',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(country),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (showExploreScrollButtons)
                    Positioned(
                      top: 0,
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
                  if (showExploreScrollButtons)
                    Positioned(
                      top: 0,
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
                  'Recommended Reads',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _recommendedReadsScrollController,
                    child: Row(
                      children: HomeScreen.recommendedReads.map((item) {
                        return Container(
                          width: 350,
                          child: BlogPostListItem(
                            postId: item.postId,
                            title: item.title,
                            summary: item.summary,
                            imageUrl: item.imageUrl,
                            imageAttribution: item.imageAttribution,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (showRecommendedReadsScrollButtons)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      child: AnimatedOpacity(
                        opacity: _showRecommendedReadsLeftScrollButton ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _showRecommendedReadsLeftScrollButton ? 40.0 : 0.0,
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
                  if (showRecommendedReadsScrollButtons)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: AnimatedOpacity(
                        opacity: _showRecommendedReadsRightScrollButton ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _showRecommendedReadsRightScrollButton ? 40.0 : 0.0,
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
          );
        },
      ),
    );
  }
}

class BlogPostListItem extends StatelessWidget {
  final String postId;
  final String title;
  final String summary;
  final String imageUrl;
  final String imageAttribution;

  const BlogPostListItem({
    Key? key,
    required this.postId,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.imageAttribution,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/post/$postId'),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Image.network(
                  imageUrl,
                  width: double.infinity, // Updated line
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      summary,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
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

  @override
  void initState() {
    super.initState();

    _post = blogPosts[widget.postId]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
    );
  }
}
