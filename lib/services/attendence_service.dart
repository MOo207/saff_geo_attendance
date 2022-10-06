import 'package:saff_geo_attendence/models/attendence.dart';
import 'package:saff_geo_attendence/services/database_service.dart';

class AttendenceService {
  // singelton
  static final AttendenceService instance = AttendenceService._();
  AttendenceService._();

  DatabaseService db = DatabaseService.instance;

  // get attendence from database
  Future<List<Attendence>> getAttendence() async {
    final List<Map<String, dynamic>> maps =
        await db.getAttendence();
    return List.generate(maps.length, (i) {
      return Attendence.fromJson(maps[i]);
    });
  }

  // get user attendence from database
  Future<List<Attendence>> getUserAttendence(int userId) async {
    final List<Attendence> attendence =
        await db.getUserAttendence(userId);
    return attendence;
  }

  // isUserAttendToday
  Future<bool> isUserAttendToday(int userId) async {
    final List<Attendence> attendence =
        await db.getUserAttendence(userId);
    if (attendence.isNotEmpty) {
      final DateTime? lastAttendence = attendence.last.attendAt;
      final DateTime now = DateTime.now();
      final DateTime nowDate = DateTime(now.year, now.month, now.day);
      return lastAttendence!.day == nowDate.day;
    }
    return false;
  }

  // add attendence
  Future<void> attendUser(Attendence attendence) async {
    await db.attendUser(attendence.toJson());
  }
}
