import 'package:flutter/material.dart';
import 'package:play_monti/constants/app_colors.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({
    super.key,
    required this.activities,
    this.onOpen,
    this.initialQuery = '',
    this.initialCategory,
  });

  final List<FavActivity> activities;
  final void Function(FavActivity activity)? onOpen;
  final String initialQuery;
  final String? initialCategory;

  @override
  State<FavoritesScreen> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesScreen> {
  final _searchCtrl = TextEditingController();
  late String _selectedCategory;

  static const textMuted = Color(0xFF666666);
  static const greenLight = Color(0xFF91A88E);

  @override
  void initState() {
    super.initState();
    _searchCtrl.text = widget.initialQuery;
    _selectedCategory = widget.initialCategory ?? 'All';
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<String> get _categories {
    final cats = <String>{};
    for (final a in widget.activities) {
      if (a.category.trim().isNotEmpty) cats.add(_labelize(a.category));
    }
    return ['All', ...cats.toList()..sort()];
  }

  String _labelize(String s) => s.trim().toLowerCase();

  List<FavActivity> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    return widget.activities.where((a) {
      final inCat = _selectedCategory == 'All'
          ? true
          : _labelize(a.category) == _labelize(_selectedCategory);
      final hay = [
        a.title,
        a.description,
        a.category,
        a.ageRange,
        ...a.tags,
      ].join(' ').toLowerCase();
      final inSearch = q.isEmpty ? true : hay.contains(q);
      return inCat && inSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor,
      ),
      body: CustomScrollView(
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
                        const Text(
                          'Favorite Activities',
                          style: TextStyle(
                              color: AppColors.kTitleBlackTextColor,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_filtered.length} saved activities',
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
                hint: 'Search favorites...',
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Categories (horizontal)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  final cat = _categories[i];
                  final selected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(
                      _titleCase(cat == 'All' ? 'All' : cat),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : textMuted,
                        fontSize: 13,
                      ),
                    ),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    selectedColor: greenLight,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                    pressElevation: 0,
                    elevation: 0,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: _categories.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // List
          if (_filtered.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _EmptyState(onClear: () {
                  setState(() {
                    _searchCtrl.clear();
                    _selectedCategory = 'All';
                  });
                }),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList.separated(
                itemBuilder: (context, i) {
                  final a = _filtered[i];
                  return _ActivityCard(
                    activity: a,
                    onTap: () => widget.onOpen?.call(a),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: _filtered.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  String _titleCase(String v) {
    if (v.isEmpty) return v;
    return v.split(' ').map((w) {
      if (w.isEmpty) return w;
      final lower = w.toLowerCase();
      return '${lower[0].toUpperCase()}${lower.substring(1)}';
    }).join(' ');
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
  const _ActivityCard({required this.activity, this.onTap});

  final FavActivity activity;
  final VoidCallback? onTap;

  static const textDark = Color(0xFF333333);
  static const textMuted = Color(0xFF666666);
  static const chipBg = Color(0xFFF9F5F0);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
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
                          _labelize(activity.category),
                          style: const TextStyle(
                            fontSize: 11,
                            color: FavoritesScreenState.greenDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        activity.ageRange,
                        style: const TextStyle(fontSize: 11, color: textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // title
                  Text(
                    activity.title,
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
                    activity.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: textMuted, fontSize: 13),
                  ),
                  const SizedBox(height: 8),

                  // tags row
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ...activity.tags.take(2).map((t) => _tag(t)),
                      if (activity.tags.length > 2)
                        Text(
                          '+${activity.tags.length - 2} more',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _labelize(String s) => s.trim().toLowerCase();

  static Widget _tag(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: chipBg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 11, color: textMuted),
        ),
      );
}

/// Empty state
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onClear});
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off,
              size: 36, color: _ActivityCard.textMuted),
          const SizedBox(height: 8),
          const Text(
            'No favorites found',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _ActivityCard.textDark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try changing filters or clearing your search.',
            style: TextStyle(color: _ActivityCard.textMuted, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onClear,
            child: const Text('Clear filters'),
          ),
        ],
      ),
    );
  }
}

/// Basit veri modeli
class FavActivity {
  final String id;
  final String title;
  final String description;
  final String emoji; // karttaki ikon (ör. "💧")
  final String category; // ör. "practical life"
  final String ageRange; // ör. "1–3 years"
  final List<String> tags;

  const FavActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.category,
    required this.ageRange,
    this.tags = const [],
  });
}

/// Kolay test için örnek veri
const demoFavorites = [
  FavActivity(
    id: 'water_pouring',
    title: 'Water Pouring',
    description:
        'Build practical life skills and hand coordination through careful water pouring.',
    emoji: '💧',
    category: 'practical life',
    ageRange: '1–3 years',
    tags: ['life skills', 'motor control', 'focus'],
  ),
];

/// ——— Helper: referans için state sınıf adını expose ———
/// (Renk sabitlerine _ActivityCard içinden de erişmek için)
class FavoritesScreenState {
  static const greenLight = Color(0xFF91A88E);
  static const greenDark = Color(0xFF6BAA75);
}
