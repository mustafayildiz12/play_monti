import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/models/guide_model.dart'; // Clipboard için

class QADetailPage extends StatefulWidget {
  const QADetailPage({super.key, required this.id, required this.qa});
  final int id;
  final QAPair qa;

  @override
  State<QADetailPage> createState() => _QADetailPageState();
}

class _QADetailPageState extends State<QADetailPage> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _fontScale =
      ValueNotifier<double>(1.0); // 0.8–1.6
  final ValueNotifier<double> _lineHeight =
      ValueNotifier<double>(1.6); // 1.2–2.0
  double _progress = 0.0;
  bool showToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // İsteğe bağlı: iOS tarzı kaydırma hissi
    // ScrollConfiguration ile de özelleştirilebilir.
  }

  void _onScroll() {
    final max = _scrollController.position.maxScrollExtent;
    final pixels = _scrollController.position.pixels;
    setState(() {
      _progress = (max == 0) ? 0 : (pixels / max).clamp(0, 1);
      showToTop = pixels > 400;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _fontScale.dispose();
    _lineHeight.dispose();
    super.dispose();
  }

  int _wordCount(String text) {
    final w = RegExp(r'(\w+)').allMatches(text);
    return w.length;
  }

  String _estimateReadTime(String text) {
    // Ortalama 200 wpm
    final words = _wordCount(text);
    final minutes = (words / 200).ceil();
    return '$minutes dak';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseTextColor = theme.colorScheme.onSurface;
    final readTime = _estimateReadTime(widget.qa.a);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: customFabButton(readTime),
      body: SafeArea(
        child: Column(
          children: [
            // Okuma İlerleme Çubuğu
            SizedBox(
              height: 4,
              child: LinearProgressIndicator(
                value: _progress, // 0'da kısa animasyon etkisi
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
              ),
            ),
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 126,
                    leading: const SizedBox(),
                    flexibleSpace: Container(
                      decoration: const BoxDecoration(),
                      child: SafeArea(
                        // üst çentik için
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topLeft, // en üste hizalar
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.white,
                                      child: InkWell(
                                        onTap: () => Navigator.pop(context),
                                        child: const Icon(Icons.arrow_back,
                                            size: 20),
                                      ),
                                    ),
                                  ),
                                  const WidgetSpan(child: SizedBox(width: 8)),
                                  TextSpan(
                                    text: ' ${widget.id}. ${widget.qa.q}',
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.kTitleBlackTextColor),
                                  ),
                                ],
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Divider(
                      height: 4,
                    ),
                  ),

                  // İçerik
                  SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          child: ValueListenableBuilder2<double, double>(
                            first: _fontScale,
                            second: _lineHeight,
                            builder: (context, scale, height, _) {
                              final baseSize = 16.0 * scale;
                              return SelectableText(
                                widget.qa.a.trim(),
                                textAlign: TextAlign.justify,
                                textHeightBehavior: const TextHeightBehavior(
                                  applyHeightToFirstAscent: false,
                                  applyHeightToLastDescent: false,
                                ),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontSize: baseSize,
                                  height: height,
                                  color: baseTextColor,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                      child: widget.id == 6
                          ? tableBody(context)
                          : const SizedBox(height: 80))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding customFabButton(String readTime) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _InfoHeader(
            readTime: readTime,
            words: _wordCount(widget.qa.a).toString(),
          ),
          const Spacer(),

          ValueListenableBuilder<double>(
            valueListenable: _fontScale,
            builder: (_, scale, __) => CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                tooltip: 'Yazı boyutu küçült',
                icon: const Icon(Icons.remove),
                onPressed: () {
                  final v = math.max(0.8, scale - 0.1);
                  _fontScale.value = double.parse(v.toStringAsFixed(2));
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Yazı büyüt
          ValueListenableBuilder<double>(
            valueListenable: _fontScale,
            builder: (_, scale, __) => CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                tooltip: 'Yazı boyutu büyüt',
                icon: const Icon(Icons.add),
                onPressed: () {
                  final v = math.min(1.6, scale + 0.1);
                  _fontScale.value = double.parse(v.toStringAsFixed(2));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding tableBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "montessoriGuide".tr,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.kTitleBlackTextColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            "essentialInsights".tr,
            style: const TextStyle(
              color: AppColors.kSubtitleTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            child: DataTable(
              dataTextStyle: const TextStyle(
                  fontSize: 14, color: AppColors.kSubtitleTextColor),
              headingTextStyle: const TextStyle(
                  fontSize: 16,
                  color: AppColors.kTitleBlackTextColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: "ComicNeue"),
              dataRowMinHeight: 60,
              dataRowMaxHeight: 75,
              dataRowColor: const WidgetStatePropertyAll(Colors.white),
              headingRowColor:
                  WidgetStateProperty.all(AppColors.kDarkGreenColor),
              border: TableBorder.all(color: AppColors.kSubtitleTextColor),
              columnSpacing: 0,
              horizontalMargin: 0,
              columns: [
                DataColumn(
                    label: Expanded(
                  child: customTableText(
                    "Özellik",
                  ),
                )),
                DataColumn(
                    label: Expanded(
                        child: customTableText("Montessori Yaklaşımı"))),
                DataColumn(
                  label: Expanded(
                    child: customTableText("Geleneksel Yaklaşım"),
                  ),
                ),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(customTableText("Öğretmenin Rolü")),
                  DataCell(customTableText(
                    "Rehber ve gözlemci",
                  )),
                  DataCell(customTableText(
                    "Kontrolör ve bilgi aktarıcısı",
                  )),
                ]),
                DataRow(cells: [
                  DataCell(customTableText("Sınıf Yapısı")),
                  DataCell(customTableText("Öğrenci merkezli, aktif katılım")),
                  DataCell(customTableText("Öğretmen merkezli, pasif dinleme")),
                ]),
                DataRow(cells: [
                  DataCell(customTableText("Yaş Grupları")),
                  DataCell(customTableText(
                      "Karma yaş grupları (genellikle 3 yaş aralığı)")),
                  DataCell(customTableText("Aynı yaştaki çocuklar bir arada")),
                ]),
                DataRow(cells: [
                  DataCell(customTableText("Öğrenme Yöntemi")),
                  DataCell(customTableText("Deneyimleyerek, somuttan soyuta")),
                  DataCell(customTableText("Ezber yoluyla, soyuttan başlama")),
                ]),
                DataRow(cells: [
                  DataCell(customTableText("Motivasyon Kaynağı")),
                  DataCell(customTableText("İçsel başarma duygusu")),
                  DataCell(customTableText("Dışsal ödül ve ceza sistemi")),
                ]),
                DataRow(cells: [
                  DataCell(customTableText("Materyal Kullanımı")),
                  DataCell(customTableText(
                      "Bireysel gelişime yönelik özel materyaller")),
                  DataCell(customTableText(
                      "Genellikle tek bir materyal veya oyuncak")),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 80)
        ],
      ),
    );
  }

  Widget customTableText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Center(
        child: Text(
          text,
          softWrap: true,
          textAlign: TextAlign.center, // text satır kırıldığında da ortalansın
        ),
      ),
    );
  }
}

// Üst bilgi rozeti + kelime sayısı
class _InfoHeader extends StatelessWidget {
  const _InfoHeader({required this.readTime, required this.words});
  final String readTime;
  final String words;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final chipStyle = t.textTheme.labelMedium;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Chip(
          avatar: const Icon(Icons.timer, size: 18),
          label: Text('Tahmini okuma: $readTime', style: chipStyle),
        ),
      ],
    );
  }
}

/// İki ValueListenable’ı birlikte dinlemek için ufak yardımcı
class ValueListenableBuilder2<A, B> extends StatelessWidget {
  const ValueListenableBuilder2({
    super.key,
    required this.first,
    required this.second,
    required this.builder,
  });

  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget Function(BuildContext, A, B, Widget?) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, a, _) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, __) => builder(context, a, b, null),
        );
      },
    );
  }
}
