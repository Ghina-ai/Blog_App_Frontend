import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/service/api.dart';

class WritePage extends StatefulWidget {
  final Future<void> Function()? onPostCreated;

  const WritePage({
    super.key, 
    this.onPostCreated,
  });

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  Uint8List? imageBytes;
  String? fileName;

  int? selectedCategoryId;
  bool isPublishing = false;

  final List<Map<String, dynamic>> categories = [
    {"id": 1, "name": "Technology"},
    {"id": 2, "name": "Lifestyle"},
    {"id": 3, "name": "Education"},
    {"id": 10, "name": "Food"},
    {"id": 11, "name": "Business"},
  ];

  // PILIH GAMBAR
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

  // PUBLISH ARTIKEL
  Future<void> publishPost() async {
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

    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan pilih kategori."),
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

    if (imageBytes == null || fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan pilih cover artikel."),
        ),
      );
      return;
    }

    setState(() {
      isPublishing = true;
    });

    try {
      await ApiService.createPost(
        title: title,
        content: content,
        categoryId: selectedCategoryId!,
        imageBytes: imageBytes!,
        fileName: fileName!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Artikel berhasil dipublikasikan!"),
        ),
      );

    await Future.delayed(
      const Duration(milliseconds: 800),
    );

    if (!mounted) return;

    await widget.onPostCreated?.call();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal membuat artikel: $e"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isPublishing = false;
        });
      }
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Write Article",
          style: TextStyle(
            color: Colors.black,
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
            // COVER
            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: double.infinity,
                height: 190,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F2F4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: imageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.memory(
                          imageBytes!,
                          width: double.infinity,
                          height: 190,
                          fit: BoxFit.cover,
                        ),
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

            const SizedBox(height: 24),

            // JUDUL
            const Text(
              "Judul Artikel",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: titleController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: "Masukkan judul artikel",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // KATEGORI
            const Text(
              "Kategori",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<int>(
              initialValue: selectedCategoryId,
              decoration: InputDecoration(
                hintText: "Pilih kategori",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: categories.map((category) {
                return DropdownMenuItem<int>(
                  value: category["id"] as int,
                  child: Text(
                    category["name"] as String,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategoryId = value;
                });
              },
            ),

            const SizedBox(height: 22),

            // ISI ARTIKEL
            const Text(
              "Isi Artikel",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: contentController,
              maxLines: 12,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: "Tulis artikel kamu di sini...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // PUBLISH
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isPublishing ? null : publishPost,
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
                child: isPublishing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Publish Article",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}