import 'package:flutter/material.dart';
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

  @override
  void initState() {
    if (Get.parameters["id"] != null) {
      id = Get.parameters["id"] ?? "";
    }
    if (Get.parameters["date"] != null) {
      dateTime = Get.parameters["date"] ?? "";
    }

    getPageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLoader(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.arrow_back,
                color: AppColors.kTitleBlackTextColor,
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                if (isFavorite) {
                  await activityService.markUnFavorite(
                      day: dateTime, activityId: activity!.day.toString());
                } else {
                  await activityService.markFavorite(
                      day: dateTime, activityModel: activity!);
                }

                await checkIsFavorite();
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.favorite,
                  color: isFavorite
                      ? Colors.redAccent
                      : AppColors.kTitleBlackTextColor,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          bottom: const PreferredSize(
              preferredSize: Size(double.infinity, 1), child: Divider()),
        ),
        body: activity == null
            ? const Center(
                child: Text("Aktivite Getirilemedi"),
              )
            : bodyWidget(),
      ),
    );
  }

  SingleChildScrollView bodyWidget() {
    List<String> steps = createSteps(activity!.stepByStep);
    List<String> materials = createMaterials(activity!.materials);
    List<String> skills = createMaterials(activity!.improvementArea);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [AppColors.kDarkGreenColor, AppColors.kLightGreenColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              activity!.emoji,
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.kMoreLightGreenColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  activity!.activityType,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.kDarkGreenColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(width: 8),
              Text(
                activity!.ageGroup.split("(").first,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.kSubtitleTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            activity!.activityName.split("(").first,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.kTitleBlackTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            activity!.clue,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.kSubtitleTextColor,
              height: 1.6,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(Icons.local_offer_outlined,
                  color: AppColors.kTitleBlackTextColor),
              const SizedBox(
                width: 8,
              ),
              Text(
                "skills".tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kTitleBlackTextColor,
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(skills.length, (index) {
              return customSkillChip(title: skills[index]);
            }),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), color: Colors.white),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Text(
                    "materials_needed".tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.kTitleBlackTextColor,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: materials.length,
                    itemBuilder: (context, index) {
                      String item = materials[index];
                      return customMaterialListItem(itemName: item);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), color: Colors.white),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Text(
                    "step_by_step".tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.kTitleBlackTextColor,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: steps.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: customStepItem(
                            number: (index + 1).toString(),
                            title: steps[index]),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.kMoreLightGreenColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.query_builder,
                  color: AppColors.kDarkGreenColor,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "activity_duration".tr,
                    style: const TextStyle(
                      fontSize: 20,
                      color: AppColors.kDarkGreenColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isMarked
                    ? AppColors.kDarkGreenColor
                    : AppColors.kButtonColor2,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.check, size: 28, color: Colors.white),
              label: Text(
                isMarked ? "completed".tr : "markAsDone".tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () async {
                if (!isMarked) {
                  await activityService.markDone(
                      day: dateTime, activityId: activity!.day.toString());
                  await checkIsMarked();
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              await showFeedbackBottomSheet();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.thumb_up, color: AppColors.kDarkGreenColor),
                  const SizedBox(width: 12),
                  Text(
                    "rate_activity".tr,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.thumb_down,
                      color:
                          AppColors.kSubtitleTextColor.withValues(alpha: 0.8)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
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
