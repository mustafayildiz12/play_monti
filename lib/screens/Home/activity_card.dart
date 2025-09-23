import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/models/final_activity_model.dart';

class ActivityCard extends StatelessWidget {
  final FinalActivityModel activity;
  final VoidCallback onTap;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          // Üste rozete çarpmaması için biraz ekstra boşluk
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // içerik kadar yükseklik
            children: [
              // Tip & Yaş grubu
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
                      activity.activityType,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.kDarkGreenColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    activity.ageGroup,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.kSubtitleTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Başlık
              Text(
                activity.activityName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kTitleBlackTextColor,
                ),
              ),
              const SizedBox(height: 8),

              // Kısa açıklama
              Text(
                activity.clue,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.kSubtitleTextColor,
                  height: 1.43,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),

              // Gelişim alanı etiketi
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.appBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  activity.improvementArea,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.kSubtitleTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Başlat butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kButtonGreenColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: Text(
                    "startActivity".tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: onTap,
                ),
              ),
              const SizedBox(height: 16),

              // İpucu bölümü
              if (activity.apothegm.isNotEmpty)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.kDarkGreenColor,
                        AppColors.kLightGreenColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "💡 ${"montessoriTip".tr}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        activity.apothegm,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          height: 1.43,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
