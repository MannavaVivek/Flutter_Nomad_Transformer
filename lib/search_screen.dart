import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'blogpost_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> filteredPosts = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> _filterPosts(String searchQuery) {
    print("searchQuery: $searchQuery");
    if (searchQuery.isEmpty) {
      return [];
    }

    final lowerCaseQuery = searchQuery.toLowerCase();
    final blogPostProvider = Provider.of<BlogPostProvider>(context, listen: false);
    final blogPosts = blogPostProvider.blogPosts;

    List<String> filteredPosts = blogPosts.keys
        .where((postId) =>
            blogPosts[postId]!.city.toLowerCase().contains(lowerCaseQuery))
        .toList();
    
    print("filteredPosts: $filteredPosts");
    return filteredPosts;
  }

  void navigateToBlogPost(String postId) {
    GoRouter.of(context).go('/post/$postId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width - 48,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: EdgeInsets.only(top: kToolbarHeight),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          filteredPosts = _filterPosts(value);
                        });
                      },
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                          color: Colors.black54,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    color:  Colors.black,
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        filteredPosts.clear();
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],

              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: List.generate(filteredPosts.length, (index) {
                final blogPostProvider = Provider.of<BlogPostProvider>(context);
                final blogPosts = blogPostProvider.blogPosts;
                final postId = filteredPosts[index];
                final blogPost = blogPosts[postId];

                return GestureDetector(
                  onTap: () => navigateToBlogPost(postId),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(blogPost!.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          blogPost.city,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          blogPost.country,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
