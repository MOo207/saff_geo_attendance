import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:saff_geo_attendence/models/user.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  // sqflite
  static Database? _database;
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    try {
      return await openDatabase(
        join(await getDatabasesPath(), 'saff_geo_attendence.db'),
        onCreate: (db, version) async {
          return await createAllTables(db);
        },
        version: 1,
      );
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // create table for user [User]
  Future<void> createUserTable(Database db) async {
    await db.execute(
      '''CREATE TABLE IF NOT EXISTS user(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL, 
        email TEXT NOT NULL, 
        password TEXT NOT NULL, 
        isLoggedIn INTEGER NOT NULL DEFAULT 0)''',
    );
  }

  // create table for attendence [attendence]
  Future<void> createAttendenceTable(db) async {
    await db.execute(
      '''CREATE TABLE IF NOT EXISTS attendence(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        attendAt TEXT NOT NULL,
        exactLocation TEXT NOT NULL,
        userId INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES user(id))''',
    );
  }

  // create all tables
  Future<void> createAllTables(Database db) async {
    try {
      await createUserTable(db);
      await createAttendenceTable(db);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> insertUser(Map<String, dynamic> user) async {
    final Database db = await database;
    await db.insert(
      'user',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertAttendence(Map<String, dynamic> attendence) async {
    final Database db = await database;
    await db.insert(
      'attendence',
      attendence,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // get user by email and password
  Future<User?> getUser(String email, String password) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAttendence() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('attendence');
    return maps;
  }

  // delete user
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(
      'user',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // delete attendence
  Future<void> deleteAttendence(int id) async {
    final db = await database;
    await db.delete(
      'attendence',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // update user
  Future<void> updateUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.update(
      'user',
      user,
      where: "id = ?",
      whereArgs: [user['id']],
    );
  }

  // update attendence
  Future<void> updateAttendence(Map<String, dynamic> attendence) async {
    final db = await database;
    await db.update(
      'attendence',
      attendence,
      where: "id = ?",
      whereArgs: [attendence['id']],
    );
  }

  // updateUserLoginStatus
  Future<void> updateUserLoginStatus(int id, bool isLoggedIn) async {
    final db = await database;
    await db.update(
      'user',
      {'isLoggedIn': isLoggedIn ? 1 : 0},
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
