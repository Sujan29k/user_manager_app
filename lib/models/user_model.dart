class User {
  final int? id;
  final String name;
  final String job;
  final String avatar;

  User({this.id, required this.name, required this.job, required this.avatar});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: "${json['first_name'] ?? ''} ${json['last_name'] ?? ''}",
      job:
          json['job'] ??
          'No job specified', // ReqRes doesn't return job in GET, but does in POST/PUT
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name, // ReqRes POST/PUT expects 'name' field
      'job': job, // ReqRes POST/PUT expects 'job' field
    };
  }
}
