class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;
  final String? job;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    this.job,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      avatar: json['avatar'] ?? '',
      job: json['job'],
    );
  }

  // Factory for API responses that return different structure (create/update)
  factory User.fromCreateUpdateJson(Map<String, dynamic> json) {
    // Handle the response from create/update which has 'name' field
    String fullName = json['name'] ?? '';
    List<String> nameParts = fullName.split(' ');

    return User(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      email: json['email'] ?? 'user@example.com',
      firstName: nameParts.isNotEmpty ? nameParts.first : 'Unknown',
      lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
      avatar: json['avatar'] ?? 'https://via.placeholder.com/150',
      job: json['job'],
    );
  }

  // Factory for JSONPlaceholder API format
  factory User.fromJsonPlaceholder(Map<String, dynamic> json) {
    String fullName = json['name'] ?? '';
    List<String> nameParts = fullName.split(' ');

    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: nameParts.isNotEmpty ? nameParts.first : 'Unknown',
      lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
      avatar:
          'https://i.pravatar.cc/150?img=${json['id'] ?? 1}', // Generate avatar URL
      job: json['company']?['catchPhrase'] ?? 'No job specified',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "avatar": avatar,
      "job": job,
    };
  }
}
