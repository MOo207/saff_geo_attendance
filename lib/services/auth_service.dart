// firebase auth service class

import 'package:flutter/foundation.dart';
import 'package:saff_geo_attendence/models/user.dart';
import 'package:saff_geo_attendence/services/database_service.dart';

class AuthService {
  // using singleton pattern
  static final AuthService _authService = AuthService._internal();
  AuthService._internal();
  factory AuthService() => _authService;

  // sqlite database service instance
  DatabaseService db = DatabaseService.instance;

  // login user
  Future<bool> login(String email, String password) async {
    try {
      // get user from database
      final User? user = await db.getUser(email, password);
      // if user is not null
      if (user != null) {
        // update user login status
        await db.updateUserLoginStatus(user.id!, true);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // logout user
  Future<bool> logout(int userId) async {
    try {
      // update user login status
      await db.updateUserLoginStatus(userId, false);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // register user by name, email and password
  Future<bool> register(String email, String password) async {
    try {
      // create user object
      final User user = User(
        email: email,
        password: password,
      );
      // insert user into database
      await db.insertUser(user.toJson());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
