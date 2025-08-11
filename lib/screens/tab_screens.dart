import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/screens/Calendar/calendar_screen.dart';
import 'package:play_monti/screens/Home/home_screen.dart';
import 'package:play_monti/screens/dummy_screens.dart';
import 'package:play_monti/screens/onboarding_flow.dart';

class MainTabNavigator extends StatefulWidget {
  const MainTabNavigator({super.key});

  @override
  State<MainTabNavigator> createState() => _MainTabNavigatorState();
}

class _MainTabNavigatorState extends State<MainTabNavigator> {
  int _selectedIndex = 0;

  // Örneğin bir yerde çağır:
  static final registration = DateTime(2025, 8, 1);

  static DateTime d(int y, int m, int d) => DateTime(y, m, d);

  static Map<DateTime, List<DailyEvent>> sampleEvents = {
    d(2025, 8, 1): [
      DailyEvent(id: '1A', isDone: true),
      DailyEvent(id: '1B', isDone: false)
    ],
    d(2025, 8, 2): [
      DailyEvent(id: '2A', isDone: true),
      DailyEvent(id: '2B', isDone: true)
    ],
    d(2025, 8, 3): [
      DailyEvent(id: '3A', isDone: false),
      DailyEvent(id: '3B', isDone: false)
    ],
    // ... her aktif gün için 2 event
  };

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      const HomeScreen(),
      StyledCalendarPage(
        registrationDate: registration,
        eventsByDay: sampleEvents,
      ),
      const OnboardingFlow(),
      const FavoritesScreen(),
      const SettingsScreen(),
    ];
    return Scaffold(
      body: widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.kDarkGreenColor,
        unselectedItemColor: const Color(0xFF999999),
        showUnselectedLabels: true,
        selectedLabelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Ionicons.home_outline),
            activeIcon: Icon(Ionicons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.calendar_outline),
            activeIcon: Icon(Ionicons.calendar),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.trophy_outline),
            activeIcon: Icon(Ionicons.trophy),
            label: 'Badges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.heart_outline),
            activeIcon: Icon(Ionicons.heart),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.settings_outline),
            activeIcon: Icon(Ionicons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
