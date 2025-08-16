import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/models/activity_list_model.dart';
import 'package:play_monti/service/activty_service.dart';

class ActivityDetailPage extends StatefulWidget {
  const ActivityDetailPage({super.key});

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  ActivityListModel? activity;

  bool isMarked = false;

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
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor,
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
        actions: const [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.favorite,
              color: AppColors.kTitleBlackTextColor,
            ),
          ),
          SizedBox(width: 16),
        ],
        bottom: const PreferredSize(
            preferredSize: Size(double.infinity, 1), child: Divider()),
      ),
      body: activity == null
          ? const Center(
              child: Text("Aktivite Getirilemedi"),
            )
          : bodyWidget(),
    );
  }

  SingleChildScrollView bodyWidget() {
    List<String> steps = createSteps(activity!.stepByStep);
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
            child: const Text(
              "💧",
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
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
                  activity!.improvementName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.kDarkGreenColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
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
          const Row(
            children: [
              Icon(Icons.local_offer_outlined,
                  color: AppColors.kTitleBlackTextColor),
              SizedBox(
                width: 8,
              ),
              Text(
                "Skills",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kTitleBlackTextColor,
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              customSkillChip(title: "life skills"),
              customSkillChip(title: "motor control"),
              customSkillChip(title: "independence"),
            ],
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
                  const Text(
                    "Materials Needed",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.kTitleBlackTextColor,
                    ),
                  ),
                  customMaterialListItem(itemName: "Small Pitcher"),
                  customMaterialListItem(itemName: "2 cups"),
                  customMaterialListItem(itemName: "Towel"),
                  customMaterialListItem(itemName: "Tray"),
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
                  const Text(
                    "Step by Step Instructions",
                    style: TextStyle(
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
                        padding: const EdgeInsets.only(bottom: 16.0),
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
            child: const Row(
              children: [
                Icon(
                  Icons.query_builder,
                  color: AppColors.kDarkGreenColor,
                  size: 28,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Duration: 15-20 Minutes",
                    style: TextStyle(
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
                isMarked ? "Completed" : "Mark as Done",
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
          )
        ],
      ),
    );
  }

  List<String> createSteps(String stepByStep) {
    // Satırlara böl
    RegExp exp = RegExp(r'\d+\.\s');

    List<String> steps =
        stepByStep.split(exp).where((e) => e.trim().isNotEmpty).toList();

    return steps;
  }

  Widget customStepItem({required String number, required String title}) {
    return Stack(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: AppColors.kButtonGreenColor),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Positioned(
          left: 48,
          top: 5,
          right: 0,
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

  Row customMaterialListItem({required String itemName}) {
    return Row(
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
    ActivityListModel? activityListModel =
        await activityService.getActivityDetail(dayIndex: id);

    if (activityListModel != null) {
      setState(() {
        activity = activityListModel;
      });
      await checkIsMarked();
    }
  }

  Future<void> checkIsMarked() async {
    // örnek: isMarked kontrolü (günü ve id’yi sen belirle)
    final done = await activityService.isMarked(
      dateTime: dateTime,
      activityId: activity!.day.toString(), // modeline göre
    );
    if (!mounted) return;
    setState(() => isMarked = done);
  }
}
