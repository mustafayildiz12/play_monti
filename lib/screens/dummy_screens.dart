import 'package:flutter/material.dart';
import 'package:play_monti/constants/jsonfiles/18-24.dart';
import 'package:play_monti/constants/jsonfiles/24-36.dart';
import 'package:play_monti/constants/jsonfiles/36-48.dart';
import 'package:play_monti/constants/jsonfiles/48-60.dart';
import 'package:play_monti/models/activity_list_model.dart';
import 'package:play_monti/service/database_service.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<ActivityListModel> activities = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () async {
              for (var element in firstList) {
                await databaseService.add1824(item: element);
              }
            },
            child: const Text("18-24"),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () async {
              for (var element in secondList) {
                await databaseService.add2436(item: element);
              }
            },
            child: const Text("24-36"),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () async {
              for (var element in thirdList) {
                await databaseService.add3648(item: element);
              }
            },
            child: const Text("36-48"),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () async {
              for (var element in fourthList) {
                await databaseService.add4860(item: element);
              }
            },
            child: const Text("48-60"),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () async {
              List<ActivityListModel> newActivites =
                  await databaseService.getActivities(path: "18-24");

              setState(() {
                activities = newActivites;
              });
            },
            child: const Text("Fetch Avticites"),
          ),
          TextButton(
            onPressed: () async {
              final now = DateTime.now().toIso8601String();
              await databaseService.setStartDate(startDate: now);
            },
            child: const Text("Set Date"),
          ),
          TextButton(
            onPressed: () async {
              List<ActivityListModel> todaysA = await databaseService
                  .getTodayActivities(activitiesPath: "18-24");

              print(todaysA.length);
            },
            child: const Text("Get 2 Activity"),
          ),
        ],
      ),
    ));
  }
}
