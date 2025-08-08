import 'package:flutter/material.dart';
import 'package:play_monti/constants/jsonfiles/18-24.dart';
import 'package:play_monti/constants/jsonfiles/24-36.dart';
import 'package:play_monti/constants/jsonfiles/36-48.dart';
import 'package:play_monti/constants/jsonfiles/48-60.dart';
import 'package:play_monti/models/activity_list_model.dart';
import 'package:play_monti/service/database_service.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Calendar Screen')),
    );
  }
}

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Badges Screen')),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Favorites Screen')),
    );
  }
}

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
              print(firstList.length);
              for (var element in firstList) {
                await databaseService.add1824(item: element);
              }
              print("done");
            },
            child: const Text("18-24"),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () async {
              print(secondList.length);
              for (var element in secondList) {
                await databaseService.add2436(item: element);
              }
              print("done");
            },
            child: const Text("24-36"),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () async {
              print(thirdList.length);
              for (var element in firstList) {
                await databaseService.add3648(item: element);
              }
              print("done");
            },
            child: const Text("36-48"),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () async {
              print(fourthList.length);
              for (var element in fourthList) {
                await databaseService.add4860(item: element);
              }
              print("done");
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
              print(activities.length);
            },
            child: const Text("Fetch Avticites"),
          ),
        ],
      ),
    ));
  }
}
