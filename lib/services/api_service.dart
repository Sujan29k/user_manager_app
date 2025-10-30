import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = "https://reqres.in/api";

  /// ✅ 1. GET — Fetch all users
  static Future<List<User>> fetchUsers() async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/users?page=2"),
            headers: {"Accept": "application/json"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ReqRes API returns data wrapped in 'data' field
        if (data['data'] == null) {
          throw Exception("Invalid API response structure");
        }

        List users = data['data'];

        // Convert each JSON user into User model using ReqRes format
        return users.map((json) => User.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception(
          "Unauthorized access. This might be a CORS issue in web browsers.",
        );
      } else {
        throw Exception("Failed to load users: HTTP ${response.statusCode}");
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception(
          "Network timeout. Please check your internet connection.",
        );
      }
      if (e.toString().contains('XMLHttpRequest') ||
          e.toString().contains('CORS')) {
        throw Exception(
          "CORS error: Please try running on mobile or desktop instead of web browser.",
        );
      }
      throw Exception("Error fetching users: $e");
    }
  }

  /// ✅ 2. POST — Create a new user
  static Future<User> createUser(String name, String job) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/users"),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode({"name": name, "job": job}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return User.fromCreateUpdateJson(data);
      } else {
        throw Exception("Failed to create user: HTTP ${response.statusCode}");
      }
    } catch (e) {
      if (e.toString().contains('XMLHttpRequest') ||
          e.toString().contains('CORS')) {
        throw Exception(
          "CORS error: Please try running on mobile or desktop instead of web browser.",
        );
      }
      throw Exception("Error creating user: $e");
    }
  }

  /// ✅ 3. PUT — Update a user
  static Future<User> updateUser(int id, String name, String job) async {
    try {
      final response = await http
          .put(
            Uri.parse("$baseUrl/users/$id"),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode({"name": name, "job": job}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromCreateUpdateJson(data);
      } else {
        throw Exception("Failed to update user: HTTP ${response.statusCode}");
      }
    } catch (e) {
      if (e.toString().contains('XMLHttpRequest') ||
          e.toString().contains('CORS')) {
        throw Exception(
          "CORS error: Please try running on mobile or desktop instead of web browser.",
        );
      }
      throw Exception("Error updating user: $e");
    }
  }

  /// ✅ 4. DELETE — Delete a user
  static Future<bool> deleteUser(int id) async {
    try {
      final response = await http
          .delete(Uri.parse("$baseUrl/users/$id"))
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 204;
    } catch (e) {
      if (e.toString().contains('XMLHttpRequest') ||
          e.toString().contains('CORS')) {
        throw Exception(
          "CORS error: Please try running on mobile or desktop instead of web browser.",
        );
      }
      throw Exception("Error deleting user: $e");
    }
  }
}
