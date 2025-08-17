import 'package:firebase_database/firebase_database.dart';
import 'package:play_monti/constants/app_constants.dart';
import 'package:play_monti/screens/Calendar/calendar_screen.dart';
import 'package:play_monti/service/authentication_service.dart';
import 'package:play_monti/service/database_service.dart';

class CalendarService {
  final FirebaseDatabase _realtimeDatabase = FirebaseDatabase.instance;

  Future<Map<DateTime, List<DailyEvent>>> buildEventsByDay() async {
    final uid = authenticationService.getUser()!.uid;
    final String group = currentMontiUser!.ageActivity!;
    final DateTime registrationDate =
        DateTime.parse(currentMontiUser!.startDate!);

    final DateTime today = DateTime.now();
    final DateTime start = DateTime(
        registrationDate.year, registrationDate.month, registrationDate.day);
    final DateTime end = DateTime(today.year, today.month, today.day + 3);

    // 1) Kullanıcının TÜM gün tamamlanmalarını tek seferde al
    final DataSnapshot allDaysSnap =
        await _realtimeDatabase.ref('userActivities/$uid/$group').get();

    final Map<String, dynamic> allDaysMap =
        (allDaysSnap.exists && allDaysSnap.value is Map)
            ? Map<String, dynamic>.from(allDaysSnap.value as Map)
            : <String, dynamic>{};

    final Map<DateTime, List<DailyEvent>> result = {};
    final int diffDays = end.difference(start).inDays;

    for (int i = 0; i <= diffDays; i++) {
      final DateTime day =
          DateTime(start.year, start.month, start.day).add(Duration(days: i));
      final String dayKey = dateKey(day);

      // 1-based: kayıt günü = 1
      final int dayIndex = i + 1;
      final int startDayNum = (dayIndex - 1) * 2 + 1; // 1,3,5,... -> 5.gün=9
      final List<int> requiredDayNumbers = [startDayNum, startDayNum + 1];

      // 2) Bu güne ait 2 aktiviteyi global içerikten getir
      final twoActs = await databaseService.getActivities(
        path: group,
        onlyDays: requiredDayNumbers,
      );

      // 3) Kullanıcının bu güne ait done node'unu normalize et (Map/List farkı)
      final dynamic dayNode = allDaysMap[dayKey];
      final Map<String, dynamic> normalizedUserActs =
          _normalizeDayNode(dayNode, requiredDayNumbers);

      // 4) DailyEvent listesi
      final dailyEvents = <DailyEvent>[];

      // a) Gelen aktiviteler üzerinden (act.day) done kontrolü
      for (final act in twoActs) {
        final int actDay = act.day;
        final raw = normalizedUserActs["$actDay"];
        final bool isDone = raw is Map ? (raw['isDone'] ?? false) : false;
        dailyEvents.add(DailyEvent(id: "$actDay", isDone: isDone));
      }

      // b) Eksik varsa requiredDayNumbers'a göre Pending/done ekle
      if (dailyEvents.length < 2) {
        final existingIds = dailyEvents.map((e) => e.id).toSet();
        for (final dn in requiredDayNumbers) {
          final key = "$dn";
          if (!existingIds.contains(key)) {
            final raw = normalizedUserActs[key];
            final bool isDone = (raw is Map && raw['isDone'] == true);
            dailyEvents.add(DailyEvent(id: key, isDone: isDone));
          }
          if (dailyEvents.length >= 2) break;
        }
      }

      result[DateTime(day.year, day.month, day.day)] = dailyEvents;
    }

    return result;
  }

  /// Gün node'unu (Map veya List) ortak Map<String,dynamic> şekline çevirir.
  /// List ise index 1 ve 2’yi sırasıyla required[0] ve required[1]'e eşler.
  Map<String, dynamic> _normalizeDayNode(
      dynamic dayNode, List<int> requiredDayNumbers) {
    final out = <String, dynamic>{};
    if (dayNode == null) return out;

    if (dayNode is Map) {
      dayNode.forEach((k, v) {
        out[k.toString()] = v;
      });
      return out;
    }

    if (dayNode is List) {
      // Eski şema: [null, {...}, {...}]  => index 1 -> first, index 2 -> second
      if (requiredDayNumbers.isNotEmpty && dayNode.length > 1) {
        final v1 = dayNode[1];
        if (v1 != null) out["${requiredDayNumbers[0]}"] = v1;
      }
      if (requiredDayNumbers.length > 1 && dayNode.length > 2) {
        final v2 = dayNode[2];
        if (v2 != null) out["${requiredDayNumbers[1]}"] = v2;
      }
      return out;
    }

    return out;
  }

  String dateKey(DateTime d) {
    final day = DateTime(d.year, d.month, d.day);
    return "${day.year.toString().padLeft(4, '0')}-"
        "${day.month.toString().padLeft(2, '0')}-"
        "${day.day.toString().padLeft(2, '0')}";
  }
}

final CalendarService calendarService = CalendarService();
