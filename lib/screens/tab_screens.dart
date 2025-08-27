import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:ionicons/ionicons.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/screens/Badges/badges_screen.dart';
import 'package:play_monti/screens/Calendar/calendar_screen.dart';
import 'package:play_monti/screens/Favorites/favorites_screen.dart';
import 'package:play_monti/screens/Guide/guide_screen.dart';
import 'package:play_monti/screens/Home/home_screen.dart';
import 'package:play_monti/screens/Settings/settings_screen.dart';

class MainTabNavigator extends StatefulWidget {
  const MainTabNavigator({super.key});

  @override
  State<MainTabNavigator> createState() => _MainTabNavigatorState();
}

class _MainTabNavigatorState extends State<MainTabNavigator> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      const HomeScreen(),
      const StyledCalendarPage(),
      const BadgesScreen(),
      const FavoritesScreen(),
      const GuidePage(),
      const SettingsPage(),
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.home_outline),
            activeIcon: const Icon(Ionicons.home),
            label: 'home'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.calendar_outline),
            activeIcon: const Icon(Ionicons.calendar),
            label: 'calendar'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.trophy_outline),
            activeIcon: const Icon(Ionicons.trophy),
            label: 'badges'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.heart_outline),
            activeIcon: const Icon(Ionicons.heart),
            label: 'favorites'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.book_outline),
            activeIcon: const Icon(Ionicons.book),
            label: 'guide'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.settings_outline),
            activeIcon: const Icon(Ionicons.settings),
            label: 'settings'.tr,
          ),
        ],
      ),
    );
  }
}
