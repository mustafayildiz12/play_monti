import 'package:flutter/material.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/constants/app_routes.dart';
import 'package:play_monti/models/final_activity_model.dart';
import 'package:play_monti/screens/Home/activity_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ActivitiesCarousel extends StatefulWidget {
  final List<FinalActivityModel> activities;
  final double cardWidth;
  final String dateKey;

  const ActivitiesCarousel(
      {super.key,
      required this.activities,
      required this.cardWidth,
      required this.dateKey});

  @override
  State<ActivitiesCarousel> createState() => _ActivitiesCarouselState();
}

class _ActivitiesCarouselState extends State<ActivitiesCarousel> {
  final PageController _pageController = PageController(viewportFraction: 1);
  int _currentIndex = 0;

  void _goToPage(int page) {
    if (page < 0 || page >= widget.activities.length) return;
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int page = _pageController.page!.round();
      if (page != _currentIndex) {
        setState(() => _currentIndex = page);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int activityCount = widget.activities.length;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 465,
          child: PageView.builder(
            controller: _pageController,
            itemCount: activityCount,
            itemBuilder: (context, index) {
              FinalActivityModel activity = widget.activities[index];
              return Center(
                child: SizedBox(
                  width: widget.cardWidth,
                  child: ActivityCard(
                    activity: activity,
                    onTap: () async {
                      String id = activity.day.toString();

                      await Navigator.pushNamed(context,
                          "${AppRoutes.activityDetailPage}/$id/${widget.dateKey}");
                    },
                  ),
                ),
              );
            },
          ),
        ),
        // Sol ok
        if (_currentIndex > 0)
          Positioned(
            left: -10,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 2,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () => _goToPage(_currentIndex - 1),
                radius: 28,
                child: const Icon(Icons.chevron_left_rounded,
                    size: 40, color: AppColors.kButtonGreenColor),
              ),
            ),
          ),
        // Sağ ok
        if (_currentIndex < activityCount - 1)
          Positioned(
            right: -10,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 2,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () => _goToPage(_currentIndex + 1),
                radius: 28,
                child: const Icon(Icons.chevron_right_rounded,
                    size: 40, color: AppColors.kButtonGreenColor),
              ),
            ),
          ),
        // Dot indicator
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: Center(
            child: SmoothPageIndicator(
              controller: _pageController,
              count: activityCount,
              effect: WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: AppColors.kDarkGreenColor,
                dotColor: Colors.grey.shade300,
                spacing: 8,
              ),
              onDotClicked: (index) => _goToPage(index),
            ),
          ),
        ),
      ],
    );
  }
}
