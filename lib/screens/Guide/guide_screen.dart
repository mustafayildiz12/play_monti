import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/models/guide_model.dart';
import 'package:play_monti/screens/Guide/guide_detail_screen.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({
    super.key,
    this.onOpen,
  });

  final void Function(GuideItem item)? onOpen;

  // Renkler (önceki ekranlarla uyumlu)
  static const bg = Color(0xFFF9F5F0);
  static const textDark = Color(0xFF333333);
  static const textMuted = Color(0xFF666666);
  static const textHint = Color(0xFF999999);
  static const greenLight = Color(0xFF91A88E);
  static const greenDark = Color(0xFF6BAA75);

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: oldBody(context),
      ),
    );
  }

  CustomScrollView oldBody(BuildContext context) {
    // Map -> List (filtre + sıraya göre)
    final entries = montessoriQA.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "montessoriGuide".tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.kTitleBlackTextColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  "essentialInsights".tr,
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
        // Guide grid (2 sütun)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid.builder(
            itemCount: entries.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // her satırda 2 kart
              crossAxisSpacing: 16, // sütun aralığı
              mainAxisSpacing: 16, // satır aralığı
              childAspectRatio: 1, // kart oranı (genişlik / yükseklik)
            ),
            itemBuilder: (context, i) {
              final id = entries[i].key;
              final qa = entries[i].value;
              return _GuideCard(
                item: qa.q,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => QADetailPage(id: id, qa: qa),
                    ),
                  );
                },
              );
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // Remember banner
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: GuidePage.greenDark,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "remember".tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "quide_subtitle".tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
class _GuideCard extends StatefulWidget {
  const _GuideCard({required this.item, this.onTap});

  final String item;
  final VoidCallback? onTap;

  static const textDark = GuidePage.textDark;
  static const greenDark = GuidePage.greenDark;

  @override
  State<_GuideCard> createState() => _GuideCardState();
}

class _GuideCardState extends State<_GuideCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        transform: _hover
            ? (Matrix4.identity()..translate(0.0, -2.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
          border: Border.all(
            color: Colors.black.withValues(alpha:_hover ? 0.06 : 0.1),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: widget.onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 140),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Üst ikon kapsülü
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: _GuideCard.greenDark,
                      ),
                      alignment: Alignment.center,
                      child: const _BookIcon(size: 24, color: Colors.white),
                    ),
                    const SizedBox(height: 16),

                    // Başlık (çok satırlı, grid’e uygun)
                    Expanded(
                      child: Text(
                        widget.item,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _GuideCard.textDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          height: 1.32,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
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
