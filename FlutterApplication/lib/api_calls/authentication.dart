import 'dart:convert';
import 'package:culture/objects/user.dart';
import 'package:http/http.dart' as http;

class Authentication {
  final String username;
  final String password;
  final String email;

  Authentication({this.username, this.password, this.email});

  Future<User> fetchUser() async {
    final response = await http.post('http://52.206.9.79/api/account/login/', body: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load User');
    }
  }
}