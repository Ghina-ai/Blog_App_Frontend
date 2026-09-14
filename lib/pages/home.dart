import 'package:flutter/material.dart';
import 'package:frontend/pages/sreach.dart';
import 'package:frontend/service/api.dart';
import 'package:frontend/pages/detail.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback onWriteTap;
  const HomePage({
    super.key,  
    required this.onSearchTap,
    required this.onWriteTap,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> posts = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await ApiService.getPosts();

      setState(() {
        posts = data;
        isLoading = false;
      });
    } catch (e) {
      print("ERROR: $e");

      setState(() {
        errorMessage = e.toString();
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

      return "${date.day} ${months[date.month - 1]} ${date.year}";
    } catch (_) {
      return raw;
    }
  }

  Widget _profileImage(String imageUrl, {double size = 18}) {
    if (imageUrl.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFE5E7EA),
        ),
        child: Icon(
          Icons.person,
          size: size * 0.65,
          color: Color(0xFF9AA1AB),
        ),
      );
    }

    return ClipOval(
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE5E7EA),
            ),
            child: Icon(
              Icons.person,
              size: size * 0.65,
              color: Color(0xFF9AA1AB),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F9FC),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF2477D4),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.wifi_off,
                  size: 40,
                  color: Color(0xFF9AA1AB),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Gagal mengambil data artikel",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7B8491),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: loadPosts,
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final featuredPost = posts.isNotEmpty ? posts[0] : null;

    final articlePosts = posts.length > 1
        ? posts.sublist(1, posts.length > 3 ? 3 : posts.length)
        : <dynamic>[];

    final forYouPosts = posts.length > 3
        ? posts.sublist(3)
        : <dynamic>[];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadPosts,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18),

                // =========================
                // HEADER
                // =========================
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Text(
                      "Blog",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF252B35),
                      ),
                    ),

                    const Spacer(),

                    GestureDetector(
                      onTap: widget.onSearchTap,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.search,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // =========================
                // GREETING
                // =========================
                const Text(
                  "Hi, Ghinaa! 👋",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF202631),
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Buatlah artikel untukmu sebanyak mungkin",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7B8491),
                  ),
                ),

                const SizedBox(height: 22),

                // =========================
                // FEATURED
                // =========================
                if (featuredPost != null)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            post: featuredPost,
                          ),
                        ),
                      );
                    },
                    child: _featuredCard(featuredPost),
                  ),

                const SizedBox(height: 25),

                if (articlePosts.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  post: articlePosts[0],
                                ),
                              ),
                            );
                          },
                          child: _articleCard(articlePosts[0]),
                        ),
                      ),
                      const SizedBox(width: 14),
                      if (articlePosts.length > 1)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    post: articlePosts[1],
                                  ),
                                ),
                              );
                            },
                            child: _articleCard(articlePosts[1]),
                          ),
                        ),
                    ],
                  ),
                const SizedBox(height: 30),

                // =========================
                // FOR YOU
                // =========================
                const Text(
                  "For You",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF252B35),
                  ),
                ),

                const SizedBox(height: 14),

                if (forYouPosts.isEmpty)
                  const Text(
                    "Belum ada artikel lainnya.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9AA1AB),
                    ),
                  )
                else
                  Column(
                    children: [
                      for (final post in forYouPosts)
                        GestureDetector(
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
                          child: _forYouCard(post),
                        ),
                    ],
                  ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // FEATURED CARD
  // =====================================================

  Widget _featuredCard(dynamic post) {
    final image = _field(post, "imageUrl");
    final category = _field(post, "categoryName", "General");
    final title = _field(post, "title", "Untitled");
    final username = _field(post, "username", "Ghinaa");
    final profileImage = _field(post, "profileImage");

    return Container(
      height: 225,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: const Color(0xFFE2E6EB),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            image.isNotEmpty
                ? Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFE2E6EB),
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: Color(0xFF9AA1AB),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: Color(0xFF9AA1AB),
                    ),
                  ),

            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xE6000000),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 18,
              right: 18,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2477D4),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      _profileImage(
                        profileImage,
                        size: 18,
                      ),

                      const SizedBox(width: 6),

                      Flexible(
                        child: Text(
                          username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Text(
                        "•",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        _formatDate(post),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // ARTICLE CARD
  // =====================================================

  Widget _articleCard(dynamic post) {
    final image = _field(post, "imageUrl");
    final category = _field(post, "categoryName", "General");
    final title = _field(post, "title", "Untitled");
    final username = _field(post, "username", "Ghinaa");
    final profileImage = _field(post, "profileImage");

    return Container(
      height: 225,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFFE2E6EB),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            image.isNotEmpty
                ? Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Color(0xFF9AA1AB),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: Color(0xFF9AA1AB),
                    ),
                  ),

            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xE6000000),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2477D4),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Row(
                    children: [
                      _profileImage(
                        profileImage,
                        size: 16,
                      ),

                      const SizedBox(width: 5),

                      Flexible(
                        child: Text(
                          username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _forYouCard(dynamic post) {
    final image = _field(post, "imageUrl");
    final category = _field(post, "categoryName", "General");
    final title = _field(post, "title", "Untitled");
    final username = _field(post, "username", "Ghinaa");
    final profileImage = _field(post, "profileImage");
    final date = _formatDate(post);

    return Container(
      width: double.infinity,
      height: 90,
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE ARTIKEL
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: image.isNotEmpty
                ? Image.network(
                    image,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 90,
                        height: 90,
                        color: const Color(0xFFE2E6EB),
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: Color(0xFF9AA1AB),
                        ),
                      );
                    },
                  )
                : Container(
                    width: 90,
                    height: 90,
                    color: const Color(0xFFE2E6EB),
                    child: const Icon(
                      Icons.image_outlined,
                      color: Color(0xFF9AA1AB),
                    ),
                  ),
          ),

          const SizedBox(width: 12),

          // CONTENT
          Expanded(
            child: SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF8D96A3),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF252B35),
                      height: 1.2,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      _profileImage(
                        profileImage,
                        size: 18,
                      ),

                      const SizedBox(width: 5),

                      Flexible(
                        child: Text(
                          username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF9AA1AB),
                          ),
                        ),
                      ),

                      const SizedBox(width: 7),

                      const Text(
                        "•",
                        style: TextStyle(
                          fontSize: 9,
                          color: Color(0xFFB8BEC7),
                        ),
                      ),

                      const SizedBox(width: 7),

                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFF9AA1AB),
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
}