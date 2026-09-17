import 'package:flutter/material.dart';
import 'package:frontend/service/api.dart';
import 'package:frontend/pages/editPosts.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> post;

  const DetailPage({
    super.key,
    required this.post,
  });

  String _field(String key) {
    final value = post[key];
    return value == null ? "" : value.toString();
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date).toLocal();

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

      return "${parsedDate.day} ${months[parsedDate.month - 1]} ${parsedDate.year}";
    } catch (_) {
      return date;
    }
  }

  void _showEditDialog(BuildContext context) {
  final titleController = TextEditingController(
    text: _field("title"),
  );

  final contentController = TextEditingController(
    text: _field("content"),
  );

  showDialog(
    context: context,
    builder: (dialogContext) {
      bool isUpdating = false;

      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text(
              "Edit Artikel",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Judul Artikel",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextField(
                    controller: contentController,
                    maxLines: 7,
                    decoration: InputDecoration(
                      labelText: "Isi Artikel",
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isUpdating
                    ? null
                    : () {
                        Navigator.pop(dialogContext);
                      },
                child: const Text("Batal"),
              ),

              ElevatedButton(
                onPressed: isUpdating
                    ? null
                    : () async {
                        if (titleController.text.trim().isEmpty ||
                            contentController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Judul dan isi artikel tidak boleh kosong.",
                              ),
                            ),
                          );
                          return;
                        }

                        setDialogState(() {
                          isUpdating = true;
                        });

                        try {
                          final postId =
                              int.parse(_field("id"));

                          await ApiService.updatePost(
                            postId,
                            titleController.text.trim(),
                            contentController.text.trim(),
                          );

                          if (!context.mounted) return;

                          Navigator.pop(dialogContext);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Artikel berhasil diperbarui!",
                              ),
                            ),
                          );

                          Navigator.pop(context, true);
                        } catch (e) {
                          setDialogState(() {
                            isUpdating = false;
                          });

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Gagal mengupdate artikel: $e",
                              ),
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2477D4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isUpdating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Simpan"),
              ),
            ],
          );
        },
      );
    },
  );
}

void _showDeleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      bool isDeleting = false;

      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFE05252),
                ),
                SizedBox(width: 8),
                Text(
                  "Hapus Artikel?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            content: const Text(
              "Artikel yang sudah dihapus tidak dapat dikembalikan.",
              style: TextStyle(
                color: Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
            actions: [
              TextButton(
                onPressed: isDeleting
                    ? null
                    : () {
                        Navigator.pop(dialogContext);
                      },
                child: const Text(
                  "Batal",
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: isDeleting
                    ? null
                    : () async {
                        setDialogState(() {
                          isDeleting = true;
                        });

                        try {
                          final postId =
                              int.parse(_field("id"));

                          await ApiService.deletePost(postId);

                          if (!context.mounted) return;

                          Navigator.pop(dialogContext);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Artikel berhasil dihapus!",
                              ),
                            ),
                          );

                          Navigator.pop(context, true);
                        } catch (e) {
                          setDialogState(() {
                            isDeleting = false;
                          });

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Gagal menghapus artikel: $e",
                              ),
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE05252),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isDeleting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Hapus"),
              ),
            ],
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final title = _field("title");
    final content = _field("content");
    final imageUrl = _field("imageUrl");
    final username = _field("username");
    final profileImage = _field("profileImage");
    final category = _field("categoryName");
    final createdAt = _field("createdAt");

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // =========================
            // IMAGE FULL SCREEN
            // =========================
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.62,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [

                    // IMAGE
                    imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return Container(
                                color: const Color(0xFFE2E6EB),
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 50,
                                  color: Color(0xFF9AA1AB),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: const Color(0xFFE2E6EB),
                            child: const Icon(
                              Icons.image_outlined,
                              size: 50,
                              color: Color(0xFF9AA1AB),
                            ),
                          ),

                    // GRADIENT
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.15),
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                          stops: const [
                            0.0,
                            0.45,
                            1.0,
                          ],
                        ),
                      ),
                    ),

                    // =========================
                    // BACK BUTTON
                    // =========================
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 12,
                      left: 20,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),
                    ),

                    // =========================
                    // TITLE + DATE
                    // =========================
                    Positioned(
                      left: 22,
                      right: 22,
                      bottom: 28,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            title,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            _formatDate(createdAt),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            // =========================
            // USER
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [

                  // PROFILE IMAGE
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: const Color(0xFFE5E7EA),
                    backgroundImage: profileImage.isNotEmpty
                        ? NetworkImage(profileImage)
                        : null,
                    child: profileImage.isEmpty
                        ? const Icon(
                            Icons.person,
                            color: Color(0xFF9AA1AB),
                          )
                        : null,
                  ),

                  const SizedBox(width: 12),

                  // USERNAME + CATEGORY
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF252B35),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8D96A3),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // =========================
            // CONTENT ARTIKEL
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.7,
                  color: Color(0xFF333943),
                ),
              ),
            ),

 
            // EDIT & DELETE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // DELETE
                    GestureDetector(
                      onTap: () {
                        _showDeleteDialog(context);
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Delete",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 18),

                    // EDIT
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPage(
                              post: post,
                            ),
                          ),
                        );

                        if (result == true && context.mounted) {
                          Navigator.pop(context, true);
                        }
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Edit",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}