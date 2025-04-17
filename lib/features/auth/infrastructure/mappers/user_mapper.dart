import 'package:teslo_shop/features/auth/domain/domain.dart' show User;

class UserMapper {
  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      roles: List<String>.from(json['roles'].map((role) => role)),
      token: json['token'],
      password: json['password'],
    );
  }
}
