// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:play_monti/constants/app_constants.dart';
import 'package:play_monti/constants/app_routes.dart';
import 'package:play_monti/service/activty_service.dart';
import 'package:play_monti/service/calendar_service.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:play_monti/constants/app_colors.dart';

class DailyEvent {
  final String id;
  final bool isDone;
  String? activityName;
  DailyEvent({required this.id, required this.isDone, this.activityName});
}

class StyledCalendarPage extends StatefulWidget {
  const StyledCalendarPage({
    super.key,
  });

  @override
  State<StyledCalendarPage> createState() => _StyledCalendarPageState();
}

class _StyledCalendarPageState extends State<StyledCalendarPage> {
  static const kText = Color(0xFF333333);
  static const kMuted = Color(0xFF666666);

  late DateTime _today;
  late DateTime _focusedMonth; // ay bazlı kontrol
  DateTime? _selectedDay;

  // Yeni: servis verisini state'te tutacağız
  DateTime? _registrationDate;
  Map<DateTime, List<DailyEvent>> _eventsByDay = {};

  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _today = _dateOnly(DateTime.now());
    _focusedMonth = DateTime(_today.year, _today.month, 1);
    _selectedDay = _today;

    _loadCalendar(); // async iş için ayrı method
  }

  Future<void> _loadCalendar() async {
    try {
      // Kullanıcının başlangıç tarihi (CalendarService içinde de kullanıyorsun ama
      // sayfanın enabledDayPredicate hesaplaması için yerelde de lazım)
      final startStr = currentMontiUser?.startDate;
      if (startStr == null || startStr.isEmpty) {
        throw Exception("Kullanıcı startDate bulunamadı.");
      }
      final reg = DateTime.parse(startStr);

      // Map<DateTime, List<DailyEvent>> verisini çek
      final map = await calendarService.buildEventsByDay();

      if (!mounted) return;
      setState(() {
        _registrationDate = _dateOnly(reg);
        _eventsByDay = map;
        loading = false;
        error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _isActiveDay(DateTime day) {
    if (_registrationDate == null) return false;
    final d = _dateOnly(day);
    final start = _registrationDate!;
    // start <= d <= today  (bugün de dahil)
    return (d.isAtSameMomentAs(start) || d.isAfter(start)) &&
            (d.isAtSameMomentAs(_today) || d.isBefore(_today)) ||
        d.isAtSameMomentAs(_today);
  }

  bool _isFuture(DateTime day) => _dateOnly(day).isAfter(_today);

  List<DailyEvent> _eventsOf(DateTime day) {
    return _eventsByDay[_dateOnly(day)] ?? const [];
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: AppColors.appBgColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (error != null) {
      return Scaffold(
        backgroundColor: AppColors.appBgColor,
        body: Center(child: Text("Hata: $error")),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        // boş başlık; kendi header’ımız var
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Activity Calendar",
              style: TextStyle(
                  color: AppColors.kTitleBlackTextColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "View the past activities and track your progress.",
              style: TextStyle(
                  color: AppColors.kSubtitleTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TableCalendar<DailyEvent>(
                  locale: 'tr_TR',
                  firstDay: DateTime(2010, 1, 1),
                  lastDay: DateTime(2030, 12, 31),
                  focusedDay: _focusedMonth,
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  availableGestures: AvailableGestures.horizontalSwipe,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month'
                  },
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                        color: AppColors.kTitleBlackTextColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                        color: AppColors.kTitleBlackTextColor,
                        fontWeight: FontWeight.w500),
                    weekendStyle: TextStyle(
                        color: AppColors.kTitleBlackTextColor,
                        fontWeight: FontWeight.w500),
                  ),
                  headerVisible: true,
                  daysOfWeekVisible: true,
                  eventLoader: _eventsOf,
                  rowHeight: 60,
                  selectedDayPredicate: (d) => isSameDay(_selectedDay, d),
                  enabledDayPredicate: (d) => _isActiveDay(d) && !_isFuture(d),
                  onPageChanged: (fd) => setState(
                      () => _focusedMonth = DateTime(fd.year, fd.month, 1)),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    cellPadding: EdgeInsets.zero,
                    tablePadding: EdgeInsets.zero,
                    markerMargin: EdgeInsets.zero,
                    cellMargin:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                    selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                    weekendTextStyle: const TextStyle(color: Colors.red),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.kLightGreenColor, // zemin şeffaf
                      shape:
                          BoxShape.rectangle, // istersen kare de yapabilirsin

                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onDaySelected: (selected, focused) async {
                    List<DailyEvent> events = _eventsOf(selected);

                    String? firstActivity = await activityService
                        .getIndexActivityName(dayIndex: events.first.id);
                    String? secondActivity = await activityService
                        .getIndexActivityName(dayIndex: events.last.id);

                    if (firstActivity != null) {
                      events.first.activityName = firstActivity;
                    }
                    if (secondActivity != null) {
                      events.last.activityName = secondActivity;
                    }

                    await calendarBottomSheet(selected, events);
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (ctx, day, _) {
                      final isToday = isSameDay(day, _today);
                      return _ActiveDayCell(
                        day: day,
                        isToday: isToday,
                        selected: isSameDay(_selectedDay, day),
                        events: _eventsOf(day),
                        onBack: _loadCalendar,
                      );
                    },
                    disabledBuilder: (ctx, day, _) {
                      final isToday = isSameDay(day, _today);
                      if (isToday) {
                        return _ActiveDayCell(
                          day: day,
                          isToday: isToday,
                          selected: isSameDay(_selectedDay, day),
                          events: _eventsOf(day),
                          onBack: _loadCalendar,
                        );
                      }
                      return _LockedDayCell(day: day);
                    },
                    markerBuilder: (ctx, day, events) {
                      if (events.isEmpty) return const SizedBox.shrink();
                      final e = events.toList();
                      return Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(e.length, (i) {
                            final color = e[i].isDone
                                ? (day.day == DateTime.now().day
                                    ? AppColors.kCalendarLightGreenColor
                                    : AppColors.kDarkGreenColor)
                                : AppColors.kCalendarLockTextColor;
                            const borderColor = Colors.white;
                            return Container(
                              width: 9,
                              height: 9,
                              margin: EdgeInsets.only(right: i == 0 ? 3 : 0),
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: .5, color: borderColor),
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(color: Color(0xFFF0F0F0)),

                // Legend
                const Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 24,
                  runSpacing: 8,
                  children: [
                    _Legend(
                        color: AppColors.kDarkGreenColor,
                        label: 'Today',
                        textOnColor: true),
                    _Legend(
                        color: AppColors.kCalendarLightGreenColor,
                        label: 'Past'),
                    _Legend(
                        color: AppColors.kCalendarLockBgColor, label: 'Locked'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> calendarBottomSheet(
      DateTime selected, List<DailyEvent> events) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _EventSheet(
        day: selected,
        events: events,
      ),
    ).then((value) {
      if (value != null && value is List) {
        String id = value.first;
        String dateKey = activityService.dateKey(value.last);
        Navigator.pushNamed(
                context, "${AppRoutes.activityDetailPage}/$id/$dateKey")
            .then((_) async {
          await _loadCalendar();
        });
      }
    });
  }
}

class _ActiveDayCell extends StatelessWidget {
  const _ActiveDayCell(
      {required this.day,
      required this.isToday,
      required this.selected,
      required this.events,
      required this.onBack});

  final DateTime day;
  final bool isToday;
  final bool selected;
  final List<DailyEvent> events;
  final Function onBack;

  static const kText = _StyledCalendarPageState.kText;

  @override
  Widget build(BuildContext context) {
    final fg = isToday ? Colors.white : kText;

    // Hover benzeri görsel geri bildirim için InkWell kullanıyoruz.
    return Container(
      width: 120,
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      decoration: BoxDecoration(
        color: AppColors.kCalendarLightGreenColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () async {
          String? firstActivity = await activityService.getIndexActivityName(
              dayIndex: events.first.id);
          String? secondActivity = await activityService.getIndexActivityName(
              dayIndex: events.last.id);

          if (firstActivity != null) {
            events.first.activityName = firstActivity;
          }
          if (secondActivity != null) {
            events.last.activityName = secondActivity;
          }

          await showModalBottomSheet(
            context: context,
            isScrollControlled: false,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (_) => _EventSheet(
              day: day,
              events:
                  events, // <-- buradaki events zaten _ActiveDayCell'e geliyor
            ),
          ).then((value) async {
            if (value != null && value is List) {
              String id = value.first;
              String date = activityService.dateKey(day);
              await Navigator.pushNamed(
                      context, "${AppRoutes.activityDetailPage}/$id/$date")
                  .then((_) async {
                onBack();
              });
            }
          });
        }, // tap event TableCalendar’dan geliyor (onDaySelected)
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.black12,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                  color: fg, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            // Dot’lar calendarBuilders.markerBuilder ile ekleniyor (Positioned bottom)
          ],
        ),
      ),
    );
  }
}

class _EventSheet extends StatelessWidget {
  const _EventSheet({
    required this.day,
    required this.events,
  });

  final DateTime day;
  final List<DailyEvent> events;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 16,
        left: 16,
        right: 16,
        top: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Başlık satırı: Tarih + durum etiketi
          Text(
            DateFormat('d MMMM y EEEE', 'tr_TR')
                .format(day), // 16 Ağustos 2025 Cumartesi
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),

          // Aktiviteler
          ...events.map((e) {
            return Column(
              children: [
                ListTile(
                  dense: false,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: Icon(
                    e.isDone
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked,
                    color: e.isDone
                        ? const Color(0xFF6BAA75)
                        : const Color(0xFFC2B9A1),
                    size: 24,
                  ),
                  title: Text(
                    // DailyEvent'e activityName/title eklediysen onu göster,
                    // yoksa fallback:
                    ((e as dynamic).activityName != null)
                        ? (e as dynamic).activityName as String
                        : 'Activity ${e.id}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    e.isDone ? 'Completed' : 'Pending',
                    style: TextStyle(
                      color: e.isDone
                          ? const Color(0xFF6BAA75)
                          : const Color(0xFF666666),
                    ),
                  ),
                  // Sağda "Git" butonu
                  trailing: TextButton.icon(
                    onPressed: () async {
                      // Önce sheet’i kapat, sonra navigasyon
                      Navigator.pop(context, [e.id, day]);
                    },
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text('Git'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const Divider(height: 1),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// Küçük yardımcı (renk koyulaştırma)

class _LockedDayCell extends StatelessWidget {
  const _LockedDayCell({required this.day});
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 1),
      decoration: BoxDecoration(
        color: AppColors.kCalendarLockBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock,
                  size: 14, color: AppColors.kCalendarLockTextColor),
              const SizedBox(height: 2),
              Text(
                '${day.day}',
                style: const TextStyle(
                    color: AppColors.kCalendarLockTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend(
      {required this.color, required this.label, this.textOnColor = false});
  final Color color;
  final String label;
  final bool textOnColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                color: _StyledCalendarPageState.kMuted, fontSize: 12)),
      ],
    );
  }
}
