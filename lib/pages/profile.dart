import 'package:flutter/material.dart';
import 'package:frontend/pages/detail.dart';
import 'package:frontend/service/api.dart';

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

      setState(() {
        profile = profileData;
        posts = postData;
        isLoading = false;
      });
    } catch (e) {
      print("PROFILE ERROR: $e");

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
        child: Icon(Icons.person, size: size * 0.65, color: Color(0xFF9AA1AB)),
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
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
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
              SizedBox(
                width: double.infinity,
                height: 230,
                child: Stack(
                  children: [
                    // BACKGROUND IMAGE
                    Image.asset(
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
                  ],
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

                    // USERNAME
                    Transform.translate(
                      offset: const Offset(0, -40),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              username,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF20242B),
                              ),
                            ),
                          ),

                          // EDIT PROFILE
                          OutlinedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(
                                    profile: profile ?? {},
                                    userId: userId,
                                  ),
                                ),
                              );

                              if (result == true) {
                                loadProfile();
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF20242B),
                              side: const BorderSide(color: Color(0xFFD8DCE2)),
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

                    // JOINED
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
                              "Joined ${_formatJoined(createdAt)}",
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

                    if (posts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            "Belum ada artikel.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),

                    for (final post in posts)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(post: post),
                            ),
                          );
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
    final date = _formatJoined(_postField(post, "createdAt"));

    return Container(
      width: double.infinity,
      height: 90,
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
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

          // TEXT
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
                      _profileImage(profileImage, size: 18),

                      const SizedBox(width: 5),

                      Flexible(
                        child: Text(
                          username.isNotEmpty ? username : "Ghinaa",
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
                        style: TextStyle(fontSize: 9, color: Color(0xFFB8BEC7)),
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

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> profile;
  final int userId;

  const EditProfilePage({
    super.key,
    required this.profile,
    required this.userId,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController bioController;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    usernameController = TextEditingController(
      text: widget.profile["username"]?.toString() ?? "",
    );

    bioController = TextEditingController(
      text: widget.profile["bio"]?.toString() ?? "",
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    setState(() {
      isSaving = true;
    });

    try {
      await ApiService.updateProfile(
        widget.userId,
        usernameController.text.trim(),
        bioController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menyimpan profile: $e")));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 19,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Username",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                hintText: "Masukkan username",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              "Bio",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: bioController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Ceritakan tentang kamu...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF20242B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Save Changes",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
