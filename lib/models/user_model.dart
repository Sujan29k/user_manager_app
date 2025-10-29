class User {
  final int id;
  final String name;
  final String job;
  final String? avatar;

  User({required this.id, required this.name, required this.job, this.avatar});

  // ✅ Convert JSON → User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      job: json['job'] ?? '',
      avatar: json['avatar'],
    );
  }

  // ✅ Convert User object → JSON (for POST/PUT requests)
  Map<String, dynamic> toJson() {
    return {'name': name, 'job': job};
  }
}
