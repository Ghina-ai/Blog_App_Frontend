import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:3000";

  //GET
  static Future<List<dynamic>> getPosts() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/posts"),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data["data"]["posts"];
      } else {
        throw Exception(
          "Gagal mengambil data posts: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("ERROR API: $e");
      throw Exception("Gagal mengambil data posts: $e");
    }
  }

//PROFILE
  static Future<Map<String, dynamic>> getProfile(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/users/$userId/profile"),
      );

      print("PROFILE STATUS: ${response.statusCode}");
      print("PROFILE RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data["data"]["profile"];
      } else {
        throw Exception(
          "Gagal mengambil profile: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("PROFILE ERROR: $e");
      throw Exception("Gagal mengambil profile: $e");
    }
  }

// GET POST
  static Future<List<dynamic>> getUserPosts(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/users/$userId/posts"),
      );

      print("USER POSTS STATUS: ${response.statusCode}");
      print("USER POSTS RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

      if (data["data"]?["post"] is List) {
        return data["data"]["post"];
      }

        return [];
      } else {
        throw Exception(
          "Gagal mengambil artikel user: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("USER POSTS ERROR: $e");
      throw Exception("Gagal mengambil artikel user: $e");
    }
  }

  // CREATE POSTS
static Future<void> createPost({
  required String title,
  required String content,
  required int categoryId,
  required Uint8List imageBytes,
  required String fileName,
}) async {
  try {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/api/v1/posts"),
    );

    request.fields["title"] = title;
    request.fields["content"] = content;
    request.fields["categoryId"] = categoryId.toString();

    request.files.add(
      http.MultipartFile.fromBytes(
        "image",
        imageBytes,
        filename: fileName,
      ),
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print("CREATE POST STATUS: ${response.statusCode}");
    print("CREATE POST RESPONSE: $responseBody");

    if (response.statusCode != 201) {
      throw Exception(
        "Gagal membuat artikel: ${response.statusCode}",
      );
    }
  } catch (e) {
    print("CREATE POST ERROR: $e");
    throw Exception("Gagal membuat artikel: $e");
  }
}
 
  // UPDATE PROFILE
static Future<void> updateProfile(
  int userId,
  String username,
  String bio, {
  Uint8List? imageBytes,
  String? fileName,
}) async {
  try {
    final request = http.MultipartRequest(
      "PATCH",
      Uri.parse("$baseUrl/api/v1/users/$userId/profile"),
    );

    request.fields["username"] = username;
    request.fields["bio"] = bio;

    if (imageBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          "image",
          imageBytes,
          filename: fileName ?? "profile.jpg",
        ),
      );
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print("UPDATE PROFILE STATUS: ${response.statusCode}");
    print("UPDATE PROFILE RESPONSE: $responseBody");

    if (response.statusCode != 200) {
      throw Exception(
        "Gagal mengupdate profile: ${response.statusCode}",
      );
    }
  } catch (e) {
    print("UPDATE PROFILE ERROR: $e");
    throw Exception("Gagal mengupdate profile: $e");
  }
}

  //UPDATE POST 
  static Future<void> updatePost(
  int postId,
  String title,
  String content, {
  Uint8List? imageBytes,
  String? fileName,
}) async {
  try {
    final request = http.MultipartRequest(
      "PATCH",
      Uri.parse("$baseUrl/api/v1/posts/$postId"),
    );

    request.fields["title"] = title;
    request.fields["content"] = content;

    if (imageBytes != null && fileName != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          "image",
          imageBytes,
          filename: fileName,
        ),
      );
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print("UPDATE POST STATUS: ${response.statusCode}");
    print("UPDATE POST RESPONSE: $responseBody");

    if (response.statusCode != 200) {
      throw Exception(
        "Gagal mengupdate artikel: ${response.statusCode}",
      );
    }
  } catch (e) {
    print("UPDATE POST ERROR: $e");
    throw Exception("Gagal mengupdate artikel: $e");
  }
}

  // DELETE POST
  static Future<void> deletePost(int postId) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/api/v1/posts/$postId"),
      );

      print("DELETE POST STATUS: ${response.statusCode}");
      print("DELETE POST RESPONSE: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception(
          "Gagal menghapus artikel: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("DELETE POST ERROR: $e");
      throw Exception("Gagal menghapus artikel: $e");
    }
  }

}