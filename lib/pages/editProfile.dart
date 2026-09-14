import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/service/api.dart';

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

  Uint8List? imageBytes;
  String? fileName;

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

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();

    setState(() {
      imageBytes = bytes;
      fileName = image.name;
    });
  }

  Future<void> saveProfile() async {
    final username = usernameController.text.trim();
    final bio = bioController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username belum diisi."),
        ),
      );
      return;
    }

    if (bio.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bio belum diisi."),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await ApiService.updateProfile(
        widget.userId,
        username,
        bio,
        imageBytes: imageBytes,
        fileName: fileName,
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menyimpan profile: $e"),
        ),
      );
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
    final oldProfileImage =
        widget.profile["profileImage"]?.toString() ?? "";

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
            Center(
              child: GestureDetector(
                onTap: pickProfileImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: const Color(0xFFE5E7EA),
                      backgroundImage: imageBytes != null
                          ? MemoryImage(imageBytes!)
                          : oldProfileImage.isNotEmpty
                              ? NetworkImage(oldProfileImage)
                              : null,
                      child: imageBytes == null &&
                              oldProfileImage.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 65,
                              color: Color(0xFF9AA1AB),
                            )
                          : null,
                    ),
                    Positioned(
                      right: 3,
                      bottom: 3,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF20242B),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                "Tap photo to change",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9AA1AB),
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              "Username",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF20242B),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                hintText: "Masukkan username",
                filled: true,
                fillColor: const Color(0xFFF7F8FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              "Bio",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF20242B),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: bioController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Ceritakan tentang kamu...",
                filled: true,
                fillColor: const Color(0xFFF7F8FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
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
                  padding: const EdgeInsets.symmetric(vertical: 15),
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
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}