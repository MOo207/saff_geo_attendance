import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:saff_geo_attendence/models/attendence.dart';
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
      // await deleteDatabase();
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

  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'saff_geo_attendence.db');
    await databaseFactory.deleteDatabase(path);
  }

  // create table for user [User]
  Future<void> createUserTable(Database db) async {
    await db.execute(
      '''CREATE TABLE IF NOT EXISTS user(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL, 
        password TEXT NOT NULL, 
        isLoggedIn INTEGER NOT NULL DEFAULT 0)''',
    );
  }

  // create table for attendence [attendence]
  Future<void> createAttendenceTable(Database db) async {
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

  Future<void> attendUser(Map<String, dynamic> attendence) async {
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

  // get user by email
  Future<User?> getUserByEmail(String email) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'email = ?',
      whereArgs: [email],
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

  // get all users
  Future<List<User>> getAllUsers() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user');
    return List.generate(maps.length, (i) {
      return User.fromJson(maps[i]);
    });
  }

  // get logged in user
  Future<User?> getLoggedInUser() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'isLoggedIn = ?',
      whereArgs: [1],
    );
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  // getUserAttendence
  Future<List<Attendence>> getUserAttendence(int userId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'attendence',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return Attendence.fromJson(maps[i]);
    });
  }

  // check if user attend today
  Future<bool> isUserAttendToday(int userId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'attendence',
      where: 'userId = ? AND attendAt = ?',
      whereArgs: [userId, DateTime.now().toIso8601String().substring(0, 10)],
    );
    return maps.isNotEmpty;
  }
}
