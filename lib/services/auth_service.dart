// firebase auth service class

import 'package:crypt/crypt.dart';
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
  Future<Map<bool, Object>> login(String email, String password) async {
    try {
      // get user from database
      final User? user = await db.getUserByEmail(email);

      // if user is not null and matched hashed password
      if (user != null && Crypt(user.password.toString()).match(password)) {
        // update user login status
        await db.updateUserLoginStatus(user.id!, true);
        Map<bool, Object> result = {true: user.toJson()};
        return result;
      }
      return {false: "User not registered or password is incorrect"};
    } catch (e) {
      debugPrint(e.toString());
      return {false: "error"};
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

  // register user by email and password and check if exist before
  Future<bool> register(String email, String password) async {
    try {
      // get user from database
      final User? user = await db.getUserByEmail(email);
      // if user is not null
      if (user != null) {
        return false;
      }
      // create new user
      await db.insertUser(User(
        email: email,
        password: Crypt.sha256(password).toString(),
      ).toJson());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // get logged in user
  Future<User?> getLoggedInUser() async {
    try {
      // get user from database
      final User? user = await db.getLoggedInUser();
      return user;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // delete account
  Future<bool> deleteAccount(int userId) async {
    try {
      // delete user from database
      await db.deleteUser(userId);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
