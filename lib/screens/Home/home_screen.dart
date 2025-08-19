import 'package:flutter/material.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/constants/app_constants.dart';
import 'package:play_monti/models/final_activity_model.dart';
import 'package:play_monti/screens/Home/activities_carousel.dart';
import 'package:play_monti/service/activty_service.dart';
import 'package:play_monti/service/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // MOCK DATA (bunları ileride Provider vs ile alabilirsin)
  final String userName = "Guest";

  final int completedCount = 8;

  int currentDayIndex = 0;
  int initialDayIndex = 0;

  List<int> dayIndexes = [];
  // Örnek ilerleme
  List<FinalActivityModel> todaysActivities = [];

  @override
  void initState() {
    getPageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final double cardWidth = width - 48;

    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good morning, $userName!",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppColors.kTitleBlackTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Today's Montessori activities are ready",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.kSubtitleTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.kButtonGreenColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      '🌱',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // HEADER
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Monthly Progress",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.kTitleBlackTextColor,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "$completedCount/30",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.kButtonGreenColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Progress Bar
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        height: 8,
                        width: ((completedCount / 30) * width)
                            .clamp(0, width - 88),
                        decoration: BoxDecoration(
                          color: AppColors.kButtonGreenColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "A new Montessori set unlocks each day",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.kSubtitleTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(dayIndexes.length, (index) {
                      int number = dayIndexes[index];
                      bool isSelected = currentDayIndex == number;

                      return GestureDetector(
                        onTap: () async {
                          await getSelectedDayActivities(number);
                          setState(() {
                            currentDayIndex = number;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.kDarkGreenColor
                                    : AppColors.kCalendarLockTextColor),
                            alignment: Alignment.center,
                            child: Text(
                              number.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  initialDayIndex == currentDayIndex
                      ? "Today's Activities"
                      : "$currentDayIndex. Gün",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kTitleBlackTextColor,
                  ),
                ),
                const SizedBox(height: 16),
                todaysActivities.isNotEmpty
                    ? ActivitiesCarousel(
                        activities: todaysActivities, // List<Activity>
                        cardWidth: cardWidth,
                        dateKey: getDateKey(),
                      )
                    : const Center(
                        child: Text("Aktivite Bulunamadı."),
                      ),
              ],
            ),
            // Daily Tip Section
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String getDateKey() {
    DateTime dateTime = DateTime.now();
    if (initialDayIndex == currentDayIndex) {
      dateTime = DateTime.now();
    } else if (initialDayIndex > currentDayIndex) {
      int difference = initialDayIndex - currentDayIndex;
      dateTime =
          DateTime(dateTime.year, dateTime.month, (dateTime.day - difference));
    } else if (initialDayIndex < currentDayIndex) {
      int difference = currentDayIndex - initialDayIndex;
      dateTime =
          DateTime(dateTime.year, dateTime.month, (dateTime.day + difference));
    }

    return activityService.dateKey(dateTime);
  }

  Future<void> getPageData() async {
    int currentDay = await databaseService.getCurrentDayIndex();

    setState(() {
      currentDayIndex = currentDay;
      initialDayIndex = currentDay;
    });
    if (currentDayIndex > 3) {
      dayIndexes = [
        currentDayIndex - 3,
        currentDayIndex - 2,
        currentDayIndex - 1,
        currentDayIndex,
        currentDayIndex + 1,
        currentDayIndex + 2,
        currentDayIndex + 3
      ];
    } else if (currentDayIndex == 1) {
      dayIndexes = [
        currentDayIndex,
        currentDayIndex + 1,
        currentDayIndex + 2,
        currentDayIndex + 3
      ];
    } else if (currentDayIndex == 2) {
      dayIndexes = [
        currentDayIndex - 1,
        currentDayIndex,
        currentDayIndex + 1,
        currentDayIndex + 2,
        currentDayIndex + 3
      ];
    } else if (currentDayIndex == 3) {
      dayIndexes = [
        currentDayIndex - 2,
        currentDayIndex - 1,
        currentDayIndex,
        currentDayIndex + 1,
        currentDayIndex + 2,
        currentDayIndex + 3
      ];
    }

    getTodaysActivities();
  }

  Future<void> getTodaysActivities() async {
    List<FinalActivityModel> todaysA = await databaseService.getTodayActivities(
        activitiesPath: currentMontiUser!.ageActivity!);

    setState(() {
      todaysActivities = todaysA;
    });
  }

  Future<void> getSelectedDayActivities(int dayIndex) async {
    List<FinalActivityModel> todaysA =
        await databaseService.getSelectedDayActivities(
            activitiesPath: currentMontiUser!.ageActivity!, dayIndex: dayIndex);

    setState(() {
      todaysActivities = todaysA;
    });
  }
}
