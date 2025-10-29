import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = "https://reqres.in/api";

  /// ✅ 1. GET — Fetch all users
  static Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/users?page=1"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List users = data['data'];

        // Convert each JSON user into User model
        return users.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load users");
      }
    } catch (e) {
      throw Exception("Error fetching users: $e");
    }
  }

  /// ✅ 2. POST — Create a new user
  static Future<User> createUser(String name, String job) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/users"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "job": job}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception("Failed to create user");
      }
    } catch (e) {
      throw Exception("Error creating user: $e");
    }
  }

  /// ✅ 3. PUT — Update a user
  static Future<User> updateUser(int id, String name, String job) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/users/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "job": job}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception("Failed to update user");
      }
    } catch (e) {
      throw Exception("Error updating user: $e");
    }
  }

  /// ✅ 4. DELETE — Delete a user
  static Future<bool> deleteUser(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/users/$id"));
      return response.statusCode == 204;
    } catch (e) {
      throw Exception("Error deleting user: $e");
    }
  }
}
