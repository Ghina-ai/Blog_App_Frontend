import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/service/api.dart';

class EditPage extends StatefulWidget {
  final Map<String, dynamic> post;

  const EditPage({
    super.key,
    required this.post,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  Uint8List? imageBytes;
  String? fileName;

  bool isUpdating = false;

  String _field(String key) {
    final value = widget.post[key];
    return value == null ? "" : value.toString();
  }

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: _field("title"),
    );

    contentController = TextEditingController(
      text: _field("content"),
    );
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();

      final image = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) return;

      final bytes = await image.readAsBytes();

      setState(() {
        imageBytes = bytes;
        fileName = image.name;

        if (fileName == null || fileName!.isEmpty) {
        fileName = "image.jpg";
      }
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal memilih gambar: $e"),
        ),
      );
    }
  }

  Future<void> updatePost() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Judul artikel belum diisi."),
        ),
      );
      return;
    }

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Isi artikel belum diisi."),
        ),
      );
      return;
    }

    setState(() {
      isUpdating = true;
    });

    try {
      final postId = int.parse(_field("id"));

      await ApiService.updatePost(
        postId,
        title,
        content,
        imageBytes: imageBytes,
        fileName: fileName,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Artikel berhasil diperbarui!"),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isUpdating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengupdate artikel: $e"),
        ),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = _field("categoryName");
    final oldImage = _field("imageUrl");

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
        ),
        title: const Text(
          "Edit Article",
          style: TextStyle(
            color: Color(0xFF252B35),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // COVER
            // =========================
            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E6EB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: imageBytes != null
                      ? Image.memory(
                          imageBytes!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : oldImage.isNotEmpty
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  oldImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (
                                    context,
                                    error,
                                    stackTrace,
                                  ) {
                                    return const Center(
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 40,
                                        color: Color(0xFF9AA1AB),
                                      ),
                                    );
                                  },
                                ),
                                Container(
                                  color: Colors.black.withOpacity(0.25),
                                ),
                                const Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.camera_alt_outlined,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        "Ganti Cover",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 40,
                                  color: Color(0xFF8D96A3),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Tambah Cover",
                                  style: TextStyle(
                                    color: Color(0xFF8D96A3),
                                  ),
                                ),
                              ],
                            ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // =========================
            // JUDUL
            // =========================
            const Text(
              "Judul Artikel",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF252B35),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: titleController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: "Masukkan judul artikel",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 22),

            // =========================
            // KATEGORI
            // =========================
            const Text(
              "Kategori",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF252B35),
              ),
            ),

            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFECEFF3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      category.isEmpty ? "General" : category,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.lock_outline,
                    size: 18,
                    color: Color(0xFF9AA1AB),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              "Kategori tidak dapat diubah.",
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF9AA1AB),
              ),
            ),

            const SizedBox(height: 22),

            // =========================
            // ISI ARTIKEL
            // =========================
            const Text(
              "Isi Artikel",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF252B35),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: contentController,
              maxLines: 12,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: "Tulis artikel kamu di sini...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // SAVE
            // =========================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isUpdating ? null : updatePost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF20242B),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF9CA3AF),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isUpdating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Simpan Perubahan",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}