import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/constants/app_localization.dart';
import 'package:play_monti/constants/app_routes.dart';
import 'package:play_monti/models/favorite_activity_model.dart';
import 'package:play_monti/service/activty_service.dart';
import 'package:play_monti/utlis/widgets/custom_loader.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({
    super.key,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesScreen> {
  final _searchCtrl = TextEditingController();

  bool isLoading = false;

  List<FavoriteActivityModel> favoriteActivityList = [];

  @override
  void initState() {
    getPageData();
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLoader(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'favorite_activities'.tr,
                              style: const TextStyle(
                                  color: AppColors.kTitleBlackTextColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalization.currentLangCode == "en"
                                  ? '${getFilteredList().length} saved activities'
                                  : '${getFilteredList().length} aktivite kaydedildi',
                              style: const TextStyle(
                                  color: AppColors.kSubtitleTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      // Kırmızı kalp ikonlu daire
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE4E6), // red-100
                          borderRadius: BorderRadius.circular(999),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.favorite,
                          color: Color(0xFFEF4444), // red-500
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          
              // Search
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _SearchField(
                    controller: _searchCtrl,
                    hint: 'searchFavorites'.tr,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ),
          
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
          
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList.separated(
                  itemBuilder: (context, i) {
                    final a = getFilteredList()[i];
                    return _ActivityCard(
                      activity: a,
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: getFilteredList().length,
                ),
              ),
          
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  List<FavoriteActivityModel> getFilteredList() {
    List<FavoriteActivityModel> filteredList = [];
    if (_searchCtrl.text.isNotEmpty) {
      filteredList = favoriteActivityList
          .where((e) =>
              e.activityName
                  .toLowerCase()
                  .contains(_searchCtrl.text.toLowerCase()) ||
              e.activityType
                  .toLowerCase()
                  .contains(_searchCtrl.text.toLowerCase()))
          .toList();
    } else {
      filteredList = favoriteActivityList;
    }
    return filteredList;
  }

  Future<void> getPageData() async {
    setState(() {
      isLoading = true;
    });
    List<FavoriteActivityModel> favs =
        await activityService.getFavoriteActivities();

    setState(() {
      favoriteActivityList = favs;
      isLoading = false;
    });
  }
}

/// Search field with leading icon & soft focus ring
class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hint,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF999999)),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 12, right: 8),
          child: Icon(Icons.search, color: _ActivityCard.textMuted),
        ),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 32, minHeight: 32),
        enabledBorder: _border(Colors.transparent),
        focusedBorder: _border(AppColors.kDarkGreenColor, width: 2),
        border: _border(Colors.transparent),
      ),
      style: const TextStyle(color: _ActivityCard.textDark),
    );
  }

  static OutlineInputBorder _border(Color c, {double width = 0}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: c, width: width),
      );
}

/// Activity card
class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity});

  final FavoriteActivityModel activity;

  static const textDark = Color(0xFF333333);
  static const textMuted = Color(0xFF666666);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        String id = activity.day.toString();
        String date = activity.date;
        await Navigator.pushNamed(
            context, "${AppRoutes.activityDetailPage}/$id/$date");
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Emoji tile with gradient
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    FavoritesScreenState.greenLight,
                    FavoritesScreenState.greenDark
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(activity.emoji, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 16),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // category + age
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F8F0),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _labelize(activity.activityType),
                          style: const TextStyle(
                            fontSize: 11,
                            color: FavoritesScreenState.greenDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        activity.ageGroup,
                        style: const TextStyle(fontSize: 11, color: textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // title
                  Text(
                    activity.activityName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: textDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // description
                  Text(
                    activity.improvementArea,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: textMuted, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _labelize(String s) => s.trim().toLowerCase();
}

/// ——— Helper: referans için state sınıf adını expose ———
/// (Renk sabitlerine _ActivityCard içinden de erişmek için)
class FavoritesScreenState {
  static const greenLight = Color(0xFF91A88E);
  static const greenDark = Color(0xFF6BAA75);
}
