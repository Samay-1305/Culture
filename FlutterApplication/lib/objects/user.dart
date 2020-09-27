class User {
  final String authKey;
  final bool success;
  final String error;

  User({this.authKey, this.success, this.error});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        authKey: json['auth_key'],
        success: json['success'],
        error: json['error']
    );
  }
}