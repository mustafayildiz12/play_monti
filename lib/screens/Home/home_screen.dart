import 'package:flutter/material.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/models/activity_list_model.dart';
import 'package:play_monti/screens/Home/activities_carousel.dart';
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
  // Örnek ilerleme
  List<ActivityListModel> todaysActivities = [];

  @override
  void initState() {
    getTodaysActivities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final double cardWidth = width - 48;

    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
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
                    // Progress Card
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
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's Activities",
                      style: TextStyle(
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
                          )
                        : const Center(
                            child: Text("Aktivite Bulunamadı."),
                          ),
                  ],
                ),
              ),
              // Daily Tip Section
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.kDarkGreenColor,
                        AppColors.kLightGreenColor
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "💡 Montessori Tip",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Let your child work at their own pace. The goal is concentration and independence, not speed.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          height: 1.43,
                          // opacity Flutter'da ayrı, burada işlevsel
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getTodaysActivities() async {
    List<ActivityListModel> todaysA =
        await databaseService.getTodayActivities(activitiesPath: "18-24");

    setState(() {
      todaysActivities = todaysA;
    });
  }
}
