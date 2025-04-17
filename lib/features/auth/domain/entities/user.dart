class User {
  final String id;
  final String fullName;
  final String email;
  final String password;
  final List<String> roles;
  final String token;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.roles,
    required this.token,
  });

  bool get isAdmin => roles.contains('admin');
}
