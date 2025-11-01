import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';

class ApiService {
  static const baseUrl = 'https://reqres.in/api';
  static final String apiKey = dotenv.env['MY_API_KEY'] ?? '';

  static Map<String, String> get headers => {
    "Content-Type": "application/json",
    "x-api-key": apiKey,
  };

  static Future<List<User>> getUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users?page=1'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List users = data['data']; // Fix: ReqRes uses 'data' not 'users'
      return users.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: headers,
      body: json.encode(user.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      // ReqRes POST returns: {"name": "...", "job": "...", "id": "...", "createdAt": "..."}
      return User(
        id: int.tryParse(data['id']?.toString() ?? '0') ?? 0,
        name: data['name'] ?? user.name,
        job: data['job'] ?? user.job,
        avatar: user.avatar, // ReqRes doesn't return avatar in POST response
      );
    } else {
      throw Exception('Failed to create user');
    }
  }

  static Future<User> updateUser(int id, User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: headers,
      body: json.encode(user.toJson()),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // ReqRes PUT returns: {"name": "...", "job": "...", "updatedAt": "..."}
      return User(
        id: id,
        name: data['name'] ?? user.name,
        job: data['job'] ?? user.job,
        avatar: user.avatar, // Keep original avatar
      );
    } else {
      throw Exception('Failed to update user');
    }
  }

  static Future<void> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$id'),
      headers: headers,
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }
}
