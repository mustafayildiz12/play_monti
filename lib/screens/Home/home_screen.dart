import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/constants/app_constants.dart';
import 'package:play_monti/models/final_activity_model.dart';
import 'package:play_monti/screens/Home/activities_carousel.dart';
import 'package:play_monti/service/activty_service.dart';
import 'package:play_monti/service/database_service.dart';
import 'package:play_monti/utlis/widgets/custom_loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "";

  int completedActivities = 0;
  int currentDayIndex = 0;
  int initialDayIndex = 0;

  List<int> dayIndexes = [];
  // Örnek ilerleme
  List<FinalActivityModel> todaysActivities = [];

  bool isLoading = false;

  @override
  void initState() {
    userName = currentMontiUser?.userName ?? "Guest";
    completedActivities = currentMontiUser!.completedActivities ?? 0;
    getPageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;

    final double cardWidth = width - 48;

    return CustomLoader(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appbarRow(),
                const SizedBox(height: 16),
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
                          Text(
                            "monthlyProgress".tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.kTitleBlackTextColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "$completedActivities / 30",
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
                            width: ((completedActivities / 30) * width)
                                .clamp(0, width - 88),
                            decoration: BoxDecoration(
                              color: AppColors.kButtonGreenColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "newSetUnlocks".tr,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.kSubtitleTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                activityDayBuilder(),
                const SizedBox(height: 8),
                Text(
                    initialDayIndex == currentDayIndex
                        ? "todaysActivities".tr
                        : "$currentDayIndex. ${"day".tr}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.kTitleBlackTextColor,
                        )),
                // Daily Tip Section
                const SizedBox(height: 16),

                todaysActivities.isNotEmpty
                    ? ActivitiesCarousel(
                        activities: todaysActivities, // List<Activity>
                        cardWidth: cardWidth,
                        dateKey: getDateKey(),
                      )
                    : Center(
                        child: Text(
                          "no_activity_found".tr,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox activityDayBuilder() {
    return SizedBox(
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
    );
  }

  Row appbarRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${"goodMorning".tr} $userName!",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.kTitleBlackTextColor,
                      )),
              const SizedBox(height: 4),
              Text(
                "todays_montissoris_ready".tr,
                style: const TextStyle(
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
            color: AppColors.kDarkGreenColor.withValues(alpha: 0.3),
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
    setState(() {
      isLoading = true;
    });
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

    await getTodaysActivities();
    setState(() {
      isLoading = false;
    });
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
