// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    User({
        this.id,
        required this.email,
        required this.password,
        this.isLoggedIn,
    });

    final int? id;
    final String? email;
    final String? password;
    final int? isLoggedIn;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? null,
        email: json["email"] ?? null,
        password: json["password"] ?? null,
        isLoggedIn: json["isLoggedIn"] ?? null,
    );

    Map<String, dynamic> toJson() => {
        "id": id ?? null,
        "email": email ?? null,
        "password": password ?? null,
        "isLoggedIn": isLoggedIn ?? null,
    };

    @override
    String toString() {
    // TODO: implement toString
    return 'User{id: $id, email: $email, password: $password, isLoggedIn: $isLoggedIn}';
  }
}
