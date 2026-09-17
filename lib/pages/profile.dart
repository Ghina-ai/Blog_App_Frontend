import 'package:flutter/material.dart';
import 'package:frontend/pages/detail.dart';
import 'package:frontend/service/api.dart';
import 'package:frontend/pages/editProfile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // GANTI kalau userId nanti diambil dari login
  final int userId = 4;

  Map<String, dynamic>? profile;
  List<dynamic> posts = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final profileData = await ApiService.getProfile(userId);
      final postData = await ApiService.getUserPosts(userId);

      if (!mounted) return;

      setState(() {
        profile = profileData;
        posts = postData;
        isLoading = false;
      });
    } catch (e) {
      print("PROFILE ERROR: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  String _field(String key) {
    final value = profile?[key];
    return value == null ? "" : value.toString();
  }

  String _formatJoined(String date) {
    try {
      final parsedDate = DateTime.parse(date).toLocal();

      const months = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      ];

      return "${parsedDate.day} ${months[parsedDate.month - 1]} ${parsedDate.year}";
    } catch (_) {
      return "";
    }
  }

  String _postField(dynamic post, String key) {
    final value = post[key];
    return value == null ? "" : value.toString();
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
          color: const Color(0xFF9AA1AB),
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
              color: const Color(0xFF9AA1AB),
            ),
          );
        },
      ),
    );
  }

  Future<void> openEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          profile: profile ?? {},
          userId: userId,
        ),
      ),
    );

    if (result == true && mounted) {
      setState(() {
        isLoading = true;
      });

      await loadProfile();
    }
  }

  Future<void> openDetail(dynamic post) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(post: post),
      ),
    );

    if (result == true && mounted) {
      await loadProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final username = _field("username");
    final bio = _field("bio");
    final profileImage = _field("profileImage");
    final createdAt = _field("createdAt");

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: loadProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // COVER
              SizedBox(
                width: double.infinity,
                height: 230,
                child: Image.asset(
                  "assets/Swiss.jpg",
                  width: double.infinity,
                  height: 230,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 230,
                      color: const Color(0xFFE8E8E8),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PROFILE IMAGE
                    Transform.translate(
                      offset: const Offset(0, -60),
                      child: CircleAvatar(
                        radius: 74,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 69,
                          backgroundColor: const Color(0xFFE5E7EA),
                          backgroundImage: profileImage.isNotEmpty
                              ? NetworkImage(profileImage)
                              : null,
                          child: profileImage.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 66,
                                  color: Color(0xFF9AA1AB),
                                )
                              : null,
                        ),
                      ),
                    ),

                    // USERNAME + EDIT
                    Transform.translate(
                      offset: const Offset(0, -40),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              username.isNotEmpty ? username : "Username",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF20242B),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          OutlinedButton(
                            onPressed: openEditProfile,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF20242B),
                              side: const BorderSide(
                                color: Color(0xFFD8DCE2),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 9,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Edit Profile",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // BIO
                    Transform.translate(
                      offset: const Offset(0, -18),
                      child: Text(
                        bio.isNotEmpty ? bio : "Belum ada bio.",
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF5F6670),
                        ),
                      ),
                    ),

                    const SizedBox(height: 2),

                    // JOINED + JUMLAH ARTIKEL
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color: Color(0xFF8A919B),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              createdAt.isNotEmpty
                                  ? "Joined ${_formatJoined(createdAt)}"
                                  : "Joined -",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF8A919B),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Text(
                          "${posts.length} Artikel",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF343A43),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ARTIKEL ANDA
                    const Text(
                      "Artikel Anda",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF20242B),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      width: 70,
                      height: 2,
                      decoration: BoxDecoration(
                        color: const Color(0xFF20242B),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // KALAU BELUM ADA ARTIKEL
                    if (posts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            "Belum ada artikel.",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                    // LIST ARTIKEL
                    for (final post in posts)
                      GestureDetector(
                        onTap: () {
                          openDetail(post);
                        },
                        child: _articleCard(post),
                      ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _articleCard(dynamic post) {
    final image = _postField(post, "imageUrl");
    final category = _postField(post, "categoryName");
    final title = _postField(post, "title");
    final username = _postField(post, "username");
    final profileImage = _postField(post, "profileImage");
    final date = _formatJoined(
      _postField(post, "createdAt"),
    );

    return Container(
      width: double.infinity,
      height: 90,
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ARTICLE IMAGE
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

          // ARTICLE TEXT
          Expanded(
            child: SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.isNotEmpty ? category : "General",
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
                    title.isNotEmpty ? title : "Untitled",
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
                          username.isNotEmpty
                              ? username
                              : "Ghinaa",
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