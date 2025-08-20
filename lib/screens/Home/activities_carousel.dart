import 'package:flutter/material.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/constants/app_routes.dart';
import 'package:play_monti/models/final_activity_model.dart';
import 'package:play_monti/screens/Home/activity_card.dart';
import 'package:play_monti/utlis/widgets/measure_size.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ActivitiesCarousel extends StatefulWidget {
  final List<FinalActivityModel> activities;
  final double cardWidth;
  final String dateKey;

  const ActivitiesCarousel({
    super.key,
    required this.activities,
    required this.cardWidth,
    required this.dateKey,
  });

  @override
  State<ActivitiesCarousel> createState() => _ActivitiesCarouselState();
}

class _ActivitiesCarouselState extends State<ActivitiesCarousel> {
  final PageController _pageController = PageController(viewportFraction: 1);
  int _currentIndex = 0;

  // Ölçülen güncel kart yüksekliği
  double _currentHeight = 0;

  // İlk frame’de ‘unbounded’ hatası almamak için geçici bir değer
  static const double _kInitialFallbackHeight = 200;

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
      final page = _pageController.page?.round() ?? 0;
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
    final count = widget.activities.length;
    final currentActivity = widget.activities[_currentIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1) Gizli ölçüm: gerçek kart yüksekliğini al
        Offstage(
          offstage: true,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: widget.cardWidth),
              child: MeasureSize(
                onChange: (size) {
                  // Ölçüm geldiğinde yüksekliği güncelle
                  if (size.height > 0 && size.height != _currentHeight) {
                    setState(() => _currentHeight = size.height);
                  }
                },
                child: ActivityCard(
                  activity: currentActivity,
                  onTap: () {}, // ölçüm için tıklama gerekmiyor
                ),
              ),
            ),
          ),
        ),

        // 2) Görünen PageView: her zaman sonlu yükseklik kullan
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: (_currentHeight == 0)
                ? _kInitialFallbackHeight
                : _currentHeight,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: count,
                  itemBuilder: (context, index) {
                    final activity = widget.activities[index];
                    return Center(
                      child: SizedBox(
                        width: widget.cardWidth,
                        child: ActivityCard(
                          activity: activity,
                          onTap: () async {
                            final id = activity.day.toString();
                            await Navigator.pushNamed(
                              context,
                              "${AppRoutes.activityDetailPage}/$id/${widget.dateKey}",
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
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
                if (_currentIndex < count - 1)
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
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        SmoothPageIndicator(
          controller: _pageController,
          count: count,
          effect: WormEffect(
            dotHeight: 10,
            dotWidth: 10,
            activeDotColor: AppColors.kDarkGreenColor,
            dotColor: Colors.grey.shade300,
            spacing: 8,
          ),
          onDotClicked: (i) => _goToPage(i),
        ),
      ],
    );
  }
}
