import 'package:flutter/material.dart';
import 'package:play_monti/constants/app_colors.dart';

class ActivityDetailPage extends StatefulWidget {
  const ActivityDetailPage({super.key});

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor,
        leading: const Icon(Icons.arrow_back),
        actions: const [Icon(Icons.favorite), Icon(Icons.download)],
        bottom: const PreferredSize(
            preferredSize: Size(double.infinity, 1), child: Divider()),
      ),
      body: SingleChildScrollView(
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
                  colors: [
                    AppColors.kDarkGreenColor,
                    AppColors.kLightGreenColor
                  ],
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
                    color: const Color(0xFFF0F8F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "practical life",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.kDarkGreenColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Text(
                  "1-3 Years",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Water Pouring",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.kTitleBlackTextColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Build practical life skills and hand coordination through careful water pouring.",
              style: TextStyle(
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
                    customStepItem(
                      number: "1",
                      title: "Fill the pitcher with water"
                    ),
                     customStepItem(
                      number: "2",
                      title: "Clean up spills together"
                    ),
                     customStepItem(
                      number: "3",
                      title: "Fill the pitcher with water"
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row customStepItem({required String number, required String title}) {
    return Row(
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
        const SizedBox(width: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.kTitleBlackTextColor,
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
        Text(
          itemName,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.kTitleBlackTextColor,
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
}
