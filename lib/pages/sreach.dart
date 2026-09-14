import 'package:flutter/material.dart';
import 'package:frontend/service/api.dart';
import 'package:frontend/pages/detail.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> posts = [];
  List<dynamic> filteredPosts = [];

  bool isLoading = true;
  String selectedCategory = "All";

  final TextEditingController searchController = TextEditingController();

  final List<String> categories = [
    "All",
    "Technology",
    "Education",
    "Lifestyle",
    "Food",
    "Business",
  ];

  @override
  void initState() {
    super.initState();
    loadPosts();

    searchController.addListener(() {
      filterPosts();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadPosts() async {
    try {
      final data = await ApiService.getPosts();

      setState(() {
        posts = data;
        filteredPosts = data;
        isLoading = false;
      });
    } catch (e) {
      print("ERROR GET POSTS: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  String _field(dynamic post, String key, [String fallback = ""]) {
    if (post == null || post is! Map) {
      return fallback;
    }

    final value = post[key];

    if (value == null) {
      return fallback;
    }

    return value.toString();
  }

  void filterPosts() {
    final keyword = searchController.text.toLowerCase().trim();

    setState(() {
      filteredPosts = posts.where((post) {
        final title = _field(post, "title").toLowerCase().trim();
        final category = _field(post, "categoryName").toLowerCase().trim();

        final matchesSearch =
            keyword.isEmpty ||
            title.contains(keyword) ||
            category.contains(keyword);

        bool matchesCategory = true;

        if (selectedCategory == "All") {
          matchesCategory = true;
        } else {
          matchesCategory =
              category == selectedCategory.toLowerCase().trim();
        }

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  String _formatDate(dynamic post) {
    final raw = _field(post, "createdAt");

    if (raw.isEmpty) {
      return "";
    }

    try {
      final date = DateTime.parse(raw).toLocal();

      const months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "Mei",
        "Jun",
        "Jul",
        "Agu",
        "Sep",
        "Okt",
        "Nov",
        "Des",
      ];

      return "${months[date.month - 1]} ${date.day} ${date.year}";
    } catch (_) {
      return raw;
    }
  }

  Widget _searchCard(dynamic post) {
    final image = _field(post, "imageUrl");
    final title = _field(post, "title", "Untitled");
    final category = _field(post, "categoryName", "General");
    final username = _field(post, "username", "Ghinaa");
    final profileImage = _field(post, "profileImage");
    final date = _formatDate(post);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Image.network(
              image,
              width: 105,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 105,
                  height: 100,
                  color: const Color(0xFFE6E9ED),
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: Color(0xFF9AA1AB),
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: SizedBox(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF8B929C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF20242B),
                      height: 1.25,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      profileImage.isNotEmpty
                          ? CircleAvatar(
                              radius: 9,
                              backgroundImage: NetworkImage(profileImage),
                            )
                          : Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFE5E7EA),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 11,
                                color: Color(0xFF9AA1AB),
                              ),
                            ),

                      const SizedBox(width: 5),

                      Flexible(
                        child: Text(
                          username,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF969DA7),
                          ),
                        ),
                      ),

                      const SizedBox(width: 7),

                      const Text(
                        "•",
                        style: TextStyle(
                          fontSize: 9,
                          color: Color(0xFFB5BAC1),
                        ),
                      ),

                      const SizedBox(width: 7),

                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFF969DA7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // TITLE
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F2F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 13),

                    const Icon(
                      Icons.search,
                      size: 21,
                      color: Color(0xFF9AA1AB),
                    ),

                    const SizedBox(width: 9),

                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9AA1AB),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // CATEGORY
            SizedBox(
              height: 34,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final active = selectedCategory == category;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });

                      filterPosts();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: active
                            ? const Color(0xFF168BD7)
                            : const Color(0xFFF0F1F3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: active
                              ? Colors.white
                              : const Color(0xFF8C939D),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            // POSTS
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF168BD7),
                      ),
                    )
                  : filteredPosts.isEmpty
                      ? const Center(
                          child: Text(
                            "Artikel tidak ditemukan",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9AA1AB),
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: loadPosts,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
                              18,
                              0,
                              18,
                              30,
                            ),
                            itemCount: filteredPosts.length,
                            itemBuilder: (context, index) {
                              final post = filteredPosts[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                        post: post,
                                      ),
                                    ),
                                  );
                                },
                                child: _searchCard(post),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}