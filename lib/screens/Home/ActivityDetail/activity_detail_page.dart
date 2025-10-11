import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/models/final_activity_model.dart';
import 'package:play_monti/screens/Home/ActivityDetail/activity_feedbak_bottom_sheet.dart';
import 'package:play_monti/service/activty_service.dart';
import 'package:play_monti/service/database_service.dart';
import 'package:play_monti/utlis/widgets/custom_loader.dart';

class ActivityDetailPage extends StatefulWidget {
  const ActivityDetailPage({super.key});

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  FinalActivityModel? activity;

  bool isMarked = false;
  bool isFavorite = false;
  bool isLoading = false;

  String id = "";
  String dateTime = "";

  List<String> assets = [
    "assets/gemini/gemini1.png",
    "assets/gemini/gemini2.png",
    "assets/gemini/gemini3.jpg",
    "assets/gemini/gemini4.jpg",
  ];

  int coverIndex = 0;

  @override
  void initState() {
    if (Get.parameters["id"] != null) {
      id = Get.parameters["id"] ?? "";
    }
    if (Get.parameters["date"] != null) {
      dateTime = Get.parameters["date"] ?? "";
    }

    final random = Random();
    setState(() {
      coverIndex = random.nextInt(assets.length);
    });

    getPageData();

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.appBgColor,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLoader(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: isLoading ? const SizedBox() : body(),
      ),
    );
  }

  Widget body() {
    final t = Theme.of(context).textTheme;
    final steps = createSteps(activity!.stepByStep);
    final materials = createMaterials(activity!.materials);
    final skills = createSkills(activity!.improvementArea);
    return CustomScrollView(
      slivers: [
        SliverLayoutBuilder(builder: (context, constraints) {
          // AppBar’ın tamamen çökmeden önceki eşik: expandedHeight - toolbarHeight
          const expanded = 250.0;
          const threshold = expanded - kToolbarHeight;
          final collapsed = constraints.scrollOffset > threshold;

          final fg = collapsed ? AppColors.kTitleBlackTextColor : Colors.white;
          final bg = collapsed ? Colors.white : Colors.transparent;

          return SliverAppBar(
            expandedHeight: expanded,
            backgroundColor: bg,
            surfaceTintColor: Colors.transparent,
            iconTheme: IconThemeData(color: fg),
            actionsIconTheme: IconThemeData(color: fg),
            titleTextStyle: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: fg, fontWeight: FontWeight.w600),
            systemOverlayStyle: collapsed
                ? SystemUiOverlayStyle.dark
                : SystemUiOverlayStyle.light,
            leading: IconButton(
              tooltip: 'Geri',
              icon: const Icon(Icons.arrow_back), // renk iconTheme’den geliyor
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                tooltip: isFavorite ? 'Favoriden çıkar' : 'Favoriye ekle',
                onPressed: _toggleFavorite,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    key: ValueKey(isFavorite),
                    Icons.favorite,
                    // renk actionsIconTheme’den gelir; özel istiyorsan fg kullan
                    color: collapsed
                        ? (isFavorite
                            ? Colors.redAccent
                            : AppColors.kTitleBlackTextColor)
                        : (isFavorite ? Colors.redAccent : Colors.white),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 12),
              title: _ReadableTitle(
                text: activity!.activityName,
                // Başlık için mini bir arka plan scrim’i (aşağıda tanımlı)
                color: fg,
                showCapsule:
                    !collapsed, // genişken kapsül arkası, çöktüğünde düz
              ),
              background: _HeaderBackground(imagePath: assets[coverIndex]),
            ),
          );
        }),

        // Üst bilgi (tip/yaş/ipuçları)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                _Tag(activity!.activityType),
                const Spacer(),
                Text(
                  activity!.ageGroup.split("(").first,
                  style: t.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _CardBlock(
            padding: const EdgeInsets.all(12),
            child: Text(
              activity!.clue,
              style: t.bodyMedium?.copyWith(color: Colors.grey[700]),
            ),
          ),
        ),

        // Yetenekler
        SliverToBoxAdapter(
          child: _SectionTitle(title: "skills".tr),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((s) => _Chip(text: s)).toList(),
            ),
          ),
        ),

        // Malzemeler
        SliverToBoxAdapter(child: _SectionTitle(title: "materials_needed".tr)),
        SliverList.builder(
          itemCount: materials.length,
          itemBuilder: (context, i) => _CardBlock(
            margin: EdgeInsets.only(
                left: 16, right: 16, top: i == 0 ? 0 : 8, bottom: 0),
            child: _MaterialRow(text: materials[i]),
          ),
        ),

        // Adım adım
        SliverToBoxAdapter(child: _SectionTitle(title: "step_by_step".tr)),
        SliverList.builder(
          itemCount: steps.length,
          itemBuilder: (context, i) => _CardBlock(
            margin: EdgeInsets.only(
                left: 16, right: 16, top: i == 0 ? 0 : 8, bottom: 0),
            child: _StepRow(number: i + 1, text: steps[i]),
          ),
        ),

        // Uyarı
        if (activity!.warningText.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: _CardBlock(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("❗", style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      activity!.warningText,
                      style: t.bodyMedium?.copyWith(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          )
        ],

        // İşlem butonları
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: Text(
                      isMarked ? "completed".tr : "markAsDone".tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isMarked
                          ? AppColors.kDarkGreenColor
                          : AppColors.kButtonColor2,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: isMarked ? null : _markDone,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: showFeedbackBottomSheet,
                  icon: const Icon(Icons.thumb_up),
                  label: Text("rate_activity".tr),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _markDone() async {
    try {
      await activityService.markDone(
          day: dateTime, activityId: activity!.day.toString());
      await checkIsMarked();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("completed".tr)),
      );
    } catch (_) {/* show error */}
  }

  Future<void> _toggleFavorite() async {
    final old = isFavorite;
    setState(() => isFavorite = !isFavorite); // optimistic
    try {
      if (isFavorite) {
        await activityService.markFavorite(
            day: dateTime, activityModel: activity!);
      } else {
        await activityService.markUnFavorite(
            day: dateTime, activityId: activity!.day.toString());
      }
    } catch (_) {
      if (mounted) setState(() => isFavorite = old); // rollback on error
    }
  }

  Future<void> showFeedbackBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FeedbackBottomSheet(
        finalActivityModel: activity!,
      ),
    );
  }

  List<String> createSteps(String stepByStep) {
    RegExp exp = RegExp(r'\d+[\.\)]\s*');

    List<String> steps =
        stepByStep.split(exp).where((e) => e.trim().isNotEmpty).toList();

    return steps;
  }

  List<String> createMaterials(String materials) {
    return materials
        .split(",") // virgüle göre ayır
        .map((e) => e.trim()) // boşlukları temizle
        .where((e) => e.isNotEmpty) // boş elemanları at
        .toList();
  }

  List<String> createSkills(String skills) {
    return skills
        .split(",") // virgüle göre ayır
        .map((e) => e.trim()) // boşlukları temizle
        .where((e) => e.isNotEmpty) // boş elemanları at
        .toList();
  }

  Widget customStepItem({required String number, required String title}) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: AppColors.kButtonGreenColor),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            strutStyle: const StrutStyle(height: 1.2, forceStrutHeight: true),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.kTitleBlackTextColor,
            ),
          ),
        )
      ],
    );
  }

  Widget customMaterialListItem({required String itemName}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.circle,
            color: AppColors.kDarkGreenColor,
            size: 16,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              itemName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.kTitleBlackTextColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  Container customSkillChip({required String title}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style:
            const TextStyle(fontSize: 14, color: AppColors.kSubtitleTextColor),
      ),
    );
  }

  Future<void> getPageData() async {
    setState(() {
      isLoading = true;
    });
    FinalActivityModel? activityListModel =
        await activityService.getActivityDetail(dayIndex: id);

    if (activityListModel != null) {
      setState(() {
        activity = activityListModel;
      });
      await checkIsMarked();
      await checkIsFavorite();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> checkIsMarked() async {
    // örnek: isMarked kontrolü (günü ve id’yi sen belirle)
    final done = await activityService.isMarked(
      dateTime: dateTime,
      activityId: activity!.day.toString(), // modeline göre
    );
    if (!mounted) return;
    setState(() => isMarked = done);

    if (done) {
      await databaseService.updateUserActivityCount(isCompleted: true);
    }
  }

  Future<void> checkIsFavorite() async {
    // örnek: isMarked kontrolü (günü ve id’yi sen belirle)
    final fav = await activityService.isFavorite(
      dateTime: dateTime,
      activityId: activity!.day.toString(), // modeline göre
    );
    if (!mounted) return;
    setState(() => isFavorite = fav);
  }
}

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground({required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: 'activity_$imagePath',
          child: ClipRRect(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(16)),
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
        // ÜST SCRIM: ikonlar için
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 120,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black54, Colors.transparent],
              ),
            ),
          ),
        ),
        // ALT SCRIM: başlık için
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 140,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black54, Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReadableTitle extends StatelessWidget {
  const _ReadableTitle(
      {required this.text, required this.color, this.showCapsule = true});
  final String text;
  final Color color;
  final bool showCapsule;

  @override
  Widget build(BuildContext context) {
    final title = Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
    );

    if (!showCapsule) return title;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(6),
      ),
      child: title,
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.kMoreLightGreenColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.kDarkGreenColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _CardBlock extends StatelessWidget {
  const _CardBlock({required this.child, this.padding, this.margin});
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(title,
          style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey[700])),
    );
  }
}

class _MaterialRow extends StatelessWidget {
  const _MaterialRow({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.circle, size: 10, color: AppColors.kDarkGreenColor),
        const SizedBox(width: 12),
        Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.number, required this.text});
  final int number;
  final String text;
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.kButtonGreenColor,
          child: Text('$number',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: t.bodyMedium)),
      ],
    );
  }
}
