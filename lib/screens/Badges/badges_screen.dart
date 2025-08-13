import 'package:flutter/material.dart';
import 'package:play_monti/constants/app_colors.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({
    super.key,
    this.totalActivities = 3,
    this.totalGoal = 30,
  });

  final int totalActivities;
  final int totalGoal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const bg = Color(0xFFF9F5F0);
    const textDark = Color(0xFF333333);
    const textMuted = Color(0xFF666666);
    const greenLight = Color(0xFF91A88E);
    const greenDark = Color(0xFF6BAA75);

    final badges = <BadgeTier>[
      BadgeTier(
        title: 'Seed',
        icon: '🌱',
        targetCount: 3,
      ),
      BadgeTier(
        title: 'Sprout',
        icon: '🌿',
        targetCount: 7,
      ),
      BadgeTier(
        title: 'Blossom',
        icon: '🌸',
        targetCount: 15,
      ),
      BadgeTier(
        title: 'Tree',
        icon: '🌳',
        targetCount: 30,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        // boş başlık; kendi header’ımız var
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Achievement Badges',
                    style: TextStyle(
                        color: AppColors.kTitleBlackTextColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Celebrate your Montessori journey milestones',
                    style: TextStyle(
                        color: AppColors.kSubtitleTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Top Summary Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Count
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          Text(
                            '$totalActivities',
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: greenLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Activities Completed',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Progress Bar (to 30)
                    AnimatedGradientBar(
                      value: (totalActivities / totalGoal).clamp(0.0, 1.0),
                      height: 12,
                      background: const Color(0xFFF0F0F0),
                      gradient: const LinearGradient(
                        colors: [greenLight, greenDark],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      radius: 999,
                      duration: const Duration(milliseconds: 600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('0',
                            style: theme.textTheme.labelSmall
                                ?.copyWith(color: textMuted)),
                        Text('$totalGoal activities',
                            style: theme.textTheme.labelSmall
                                ?.copyWith(color: textMuted)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Badge Cards
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.separated(
              itemBuilder: (context, index) {
                final tier = badges[index];
                final earned = totalActivities >= tier.targetCount;
                final progress =
                    (totalActivities / tier.targetCount).clamp(0.0, 1.0);
                return BadgeCard(
                  title: tier.title,
                  icon: tier.icon,
                  targetCount: tier.targetCount,
                  currentCount: totalActivities,
                  earned: earned,
                  progress: progress,
                  colors: (earned
                      ? BadgeColors(
                          ringColor: greenLight.withOpacity(0.2),
                          circleGradient: const LinearGradient(
                            colors: [
                              Color(0xFF4ADE80), // green-400-ish
                              Color(0xFF22C55E), // green-500-ish
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          progressColorA: greenLight,
                          progressColorB: greenDark,
                          textMain: textDark,
                          textSub: textMuted,
                        )
                      : BadgeColors(
                          ringColor: Colors.transparent,
                          circleGradient: const LinearGradient(
                            colors: [Color(0xFFF5F5F5), Color(0xFFF5F5F5)],
                          ),
                          progressColorA: greenLight,
                          progressColorB: greenLight,
                          textMain: const Color(0xFF999999),
                          textSub: const Color(0xFF999999),
                        )),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: badges.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // CTA Banner
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [greenLight, greenDark],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Keep Growing! 🌱',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Every activity completed is a step forward in your child's development journey.",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Data model for a badge tier
class BadgeTier {
  final String title;
  final String icon; // emoji for simplicity
  final int targetCount;

  BadgeTier({
    required this.title,
    required this.icon,
    required this.targetCount,
  });
}

/// Colors and theming bundle per-card
class BadgeColors {
  final Color ringColor;
  final LinearGradient circleGradient;
  final Color progressColorA;
  final Color progressColorB;
  final Color textMain;
  final Color textSub;

  BadgeColors({
    required this.ringColor,
    required this.circleGradient,
    required this.progressColorA,
    required this.progressColorB,
    required this.textMain,
    required this.textSub,
  });
}

/// Individual Badge Card
class BadgeCard extends StatelessWidget {
  const BadgeCard({
    super.key,
    required this.title,
    required this.icon,
    required this.targetCount,
    required this.currentCount,
    required this.earned,
    required this.progress,
    required this.colors,
  });

  final String title;
  final String icon;
  final int targetCount;
  final int currentCount;
  final bool earned;
  final double progress;
  final BadgeColors colors;

  @override
  Widget build(BuildContext context) {
    final ring = colors.ringColor;
    final textMain = colors.textMain;
    final textSub = colors.textSub;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // subtle ring for earned ones
        boxShadow: [
          if (ring.opacity > 0)
            BoxShadow(
              color: ring,
              blurRadius: 0,
              spreadRadius: 2,
            ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Icon Circle (with grayscale if locked)
          ColorFiltered(
            colorFilter: earned
                ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
                : const ColorFilter.matrix(<double>[
                    // grayscale matrix
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0, 0, 0, 1, 0,
                  ]),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: colors.circleGradient,
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.center,
              child: Text(
                icon,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Texts + progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + check
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: textMain,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (earned)
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6BAA75),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.check,
                            size: 14, color: Colors.white),
                      ),
                  ],
                ),
                const SizedBox(height: 6),

                // Subtitle / requirement
                Text(
                  'Complete $targetCount activities',
                  style: TextStyle(
                    fontSize: 13,
                    color: earned ? textSub : textSub,
                  ),
                ),
                const SizedBox(height: 10),

                // Progress bar + ratio for locked ones
                if (!earned) ...[
                  AnimatedGradientBar(
                    value: progress,
                    height: 8,
                    background: const Color(0xFFF0F0F0),
                    gradient: LinearGradient(
                      colors: [colors.progressColorA, colors.progressColorB],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    radius: 999,
                    duration: const Duration(milliseconds: 500),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$currentCount/$targetCount activities',
                    style: TextStyle(fontSize: 12, color: textSub),
                  ),
                ] else ...[
                  const Text(
                    'Earned! 🎉',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6BAA75),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated linear gradient progress bar
class AnimatedGradientBar extends StatelessWidget {
  const AnimatedGradientBar({
    super.key,
    required this.value,
    required this.height,
    required this.background,
    required this.gradient,
    required this.radius,
    this.duration = const Duration(milliseconds: 400),
  });

  final double value; // 0..1
  final double height;
  final Color background;
  final Gradient gradient;
  final double radius;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: height,
        color: background,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxW = constraints.maxWidth;
            return Align(
              alignment: Alignment.centerLeft,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
                duration: duration,
                curve: Curves.easeOutCubic,
                builder: (context, v, _) {
                  return Container(
                    width: maxW * v,
                    decoration: BoxDecoration(gradient: gradient),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
