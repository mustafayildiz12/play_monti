import 'package:flutter/material.dart';
import 'package:play_monti/constants/app_colors.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({
    super.key,
    this.items = demoGuides,
    this.onOpen,
    this.title = 'Montessori Guide',
    this.subtitle = 'Essential insights for your Montessori journey',
  });

  final List<GuideItem> items;
  final void Function(GuideItem item)? onOpen;
  final String title;
  final String subtitle;

  // Renkler (önceki ekranlarla uyumlu)
  static const bg = Color(0xFFF9F5F0);
  static const textDark = Color(0xFF333333);
  static const textMuted = Color(0xFF666666);
  static const textHint = Color(0xFF999999);
  static const greenLight = Color(0xFF91A88E);
  static const greenDark = Color(0xFF6BAA75);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          color: AppColors.kTitleBlackTextColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                          color: AppColors.kSubtitleTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),

            // Guide list
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.separated(
                itemBuilder: (context, i) {
                  final item = items[i];
                  return _GuideCard(
                    item: item,
                    onTap: () => onOpen?.call(item),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: items.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Remember banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:16),
                child: Container(
                  decoration: BoxDecoration(
                    color: greenDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '💡 Remember',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Montessori is not about perfection—it's about progress. Every small step towards independence is a victory worth celebrating.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tek bir rehber öğesi
class GuideItem {
  final String id;
  final String title;
  final String excerpt;
  final int minutes; // okuma süresi
  final String
      icon; // emoji yerine SVG kullanmak istersen burada path da tutabilirsin

  const GuideItem({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.minutes,
    this.icon = 'book',
  });
}

/// Kart bileşeni
class _GuideCard extends StatelessWidget {
  const _GuideCard({required this.item, this.onTap});

  final GuideItem item;
  final VoidCallback? onTap;

  static const textDark = GuidePage.textDark;
  static const textMuted = GuidePage.textMuted;
  static const textHint = GuidePage.textHint;
  static const green = GuidePage.greenLight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sol ikon kutusu
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: green,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const _BookIcon(size: 24, color: Colors.white),
              ),
              const SizedBox(width: 16),

              // Metinler
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Başlık
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Excerpt
                    Text(
                      item.excerpt,
                      style: const TextStyle(
                        color: textMuted,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Okuma süresi
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _ClockIcon(size: 16, color: textHint),
                        const SizedBox(width: 6),
                        Text(
                          '${item.minutes} min read',
                          style: const TextStyle(
                            color: textHint,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // İsteğe bağlı sağ ok
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: textHint),
            ],
          ),
        ),
      ),
    );
  }
}

/// Basit saat ikonu (stroke)
class _ClockIcon extends StatelessWidget {
  const _ClockIcon({this.size = 18, this.color = Colors.black54});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ClockPainter(color),
      ),
    );
  }
}

class _ClockPainter extends CustomPainter {
  _ClockPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final c = Offset(r, r);

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Dış çember
    canvas.drawCircle(c, r - 1, stroke);

    // Akrep & yelkovan
    final center = c;
    final hour = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final minute = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // 12 -> 12, 4 yönünde (örnek: 12:20 gibi)
    canvas.drawLine(center, center + Offset(0, -r / 2), hour);
    canvas.drawLine(center, center + Offset(r / 2, r / 3), minute);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Basit kitap ikonu (stroke)
class _BookIcon extends StatelessWidget {
  const _BookIcon({this.size = 24, this.color = Colors.black});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _BookPainter(color)),
    );
  }
}

class _BookPainter extends CustomPainter {
  _BookPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Sol kapak
    final left = Path()
      ..moveTo(w * 0.1, h * 0.2)
      ..lineTo(w * 0.5, h * 0.2)
      ..quadraticBezierTo(w * 0.6, h * 0.2, w * 0.6, h * 0.35)
      ..lineTo(w * 0.6, h * 0.9)
      ..quadraticBezierTo(w * 0.45, h * 0.7, w * 0.1, h * 0.7)
      ..lineTo(w * 0.1, h * 0.2);

    // Sağ kapak
    final right = Path()
      ..moveTo(w * 0.9, h * 0.2)
      ..lineTo(w * 0.5, h * 0.2)
      ..quadraticBezierTo(w * 0.4, h * 0.2, w * 0.4, h * 0.35)
      ..lineTo(w * 0.4, h * 0.9)
      ..quadraticBezierTo(w * 0.55, h * 0.7, w * 0.9, h * 0.7)
      ..lineTo(w * 0.9, h * 0.2);

    canvas.drawPath(left, p);
    canvas.drawPath(right, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Örnek veri
const demoGuides = [
  GuideItem(
    id: 'what_is_montessori',
    title: 'What is Montessori?',
    excerpt:
        'Discover the core principles of Montessori education and how it nurtures independent, confident children.',
    minutes: 5,
  ),
  GuideItem(
    id: 'observe_your_child',
    title: 'How to Observe Your Child',
    excerpt:
        "Learn the art of observation to understand your child's interests, needs, and developmental stage.",
    minutes: 4,
  ),
  GuideItem(
    id: 'setup_space',
    title: 'Setting up a Montessori Space at Home',
    excerpt:
        'Create an environment that promotes independence and learning with simple, practical changes.',
    minutes: 6,
  ),
];
