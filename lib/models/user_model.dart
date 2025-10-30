class User {
  final int? id;
  final String name;
  final String job;
  final String avatar;

  User({
    this.id,
    required this.name,
    required this.job,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: "${json['firstName']} ${json['lastName']}",
      job: json['company'] != null ? json['company']['title'] ?? '' : '',
      avatar: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': name.split(' ').first,
      'lastName': name.split(' ').length > 1 ? name.split(' ')[1] : '',
      'company': {'title': job},
      'image': avatar,
    };
  }
}
