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

  // CREATE POST
  static Future<void> createPost({
    required String title,
    required String content,
    required int categoryId, Uint8List? imageBytes, String? fileName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/posts"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "title": title,
          "content": content,
          "categoryId": categoryId,
        }),
      );

      print("CREATE POST STATUS: ${response.statusCode}");
      print("CREATE POST RESPONSE: ${response.body}");

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
    String bio,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse("$baseUrl/api/v1/users/$userId/profile"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "bio": bio,
        }),
      );

      print("UPDATE PROFILE STATUS: ${response.statusCode}");
      print("UPDATE PROFILE RESPONSE: ${response.body}");

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
}