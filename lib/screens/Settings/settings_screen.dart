import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:play_monti/constants/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    this.username = 'mustti',
    this.language = 'Turkish',
    this.ageLabel = '🧒 3–8 years',
    this.notificationsOn = true,
    this.version = 'v1.0.0',
    this.onLanguageChanged,
    this.onAgeGroupChanged,
    this.onNotificationsChanged,
    this.onFeedbackTap,
  });

  final String username;
  final String language;
  final String ageLabel;
  final bool notificationsOn;
  final String version;

  final ValueChanged<String>? onLanguageChanged;
  final ValueChanged<String>? onAgeGroupChanged;
  final ValueChanged<bool>? onNotificationsChanged;
  final VoidCallback? onFeedbackTap;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Palette (önceki ekranlarla uyumlu)
  static const bg = Color(0xFFF9F5F0);
  static const textDark = Color(0xFF333333);
  static const textMuted = Color(0xFF666666);
  static const textHint = Color(0xFF999999);
  static const greenLight = Color(0xFF91A88E);
  static const greenDark = Color(0xFF6BAA75);

  late String _language;
  late String _ageLabel;
  late bool _notificationsOn;

  @override
  void initState() {
    super.initState();
    _language = widget.language;
    _ageLabel = widget.ageLabel;
    _notificationsOn = widget.notificationsOn;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(backgroundColor: AppColors.appBgColor),
      body: CustomScrollView(
        slivers: [
          // Header
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                        color: AppColors.kTitleBlackTextColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Customize your MontiTime experience',
                    style: TextStyle(
                        color: AppColors.kSubtitleTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),

          // Profile card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: greenLight,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.person,
                          color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.username,
                              style: const TextStyle(
                                color: textDark,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              )),
                          const SizedBox(height: 4),
                          Text(
                            '$_language • $_ageLabel',
                            style:
                                const TextStyle(color: textMuted, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Language
          _SliverSettingTile(
            leadingBg: const Color(0xFFF0F8F0),
            leadingIcon: Ionicons.globe_outline,
            onTap: _pickLanguage,
            title: 'Language',
            subtitle: _language,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Age group
          _SliverSettingTile(
            leadingBg: const Color(0xFFF0F8F0),
            leadingIcon: Ionicons.people,
            onTap: _pickAgeGroup,
            title: "Child's Age Group",
            subtitle: _ageLabel,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Notifications (switch)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Row(
                  children: [
                    const _LeadingIcon(
                      bg: Color(0xFFF0F8F0),
                      icon: Ionicons.notifications_outline,
                      iconColor: greenDark,
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Notifications',
                              style: TextStyle(
                                color: textDark,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              )),
                          SizedBox(height: 2),
                          Text('Daily activity reminders',
                              style: TextStyle(color: textMuted, fontSize: 13)),
                        ],
                      ),
                    ),
                    // Custom switch görünümü
                    GestureDetector(
                      onTap: () => _toggleNotifications(!_notificationsOn),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 54,
                        height: 28,
                        decoration: BoxDecoration(
                          color: _notificationsOn
                              ? greenLight
                              : const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        alignment: _notificationsOn
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Feedback
          _SliverSettingTile(
            leadingBg: const Color(0xFFF0F8F0),
            leadingIcon: Ionicons.chatbox_outline,
            onTap: widget.onFeedbackTap ??
                () {
                  // Basit demo: SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Thanks for helping us improve MontiTime!')),
                  );
                },
            title: 'Send Feedback',
            subtitle: 'Help us improve MontiTime',
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Footer
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  Text(
                    'MontiTime ${widget.version}',
                    style: const TextStyle(color: textHint, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Made with 🌱 for growing minds',
                    style: TextStyle(color: textHint, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ——— Actions ———

  Future<void> _pickLanguage() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _PickerSheet(
        title: 'Choose language',
        options: const ['Turkish', 'English', 'Deutsch', 'Français', 'Español'],
        initial: _language,
      ),
    );
    if (selected != null && selected != _language) {
      setState(() => _language = selected);
      widget.onLanguageChanged?.call(selected);
    }
  }

  Future<void> _pickAgeGroup() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _PickerSheet(
        title: "Choose child's age group",
        options: const [
          '👶 0–2 years',
          '🧒 3–8 years',
          '🧑 9–12 years',
        ],
        initial: _ageLabel,
      ),
    );
    if (selected != null && selected != _ageLabel) {
      setState(() => _ageLabel = selected);
      widget.onAgeGroupChanged?.call(selected);
    }
  }

  void _toggleNotifications(bool v) {
    setState(() => _notificationsOn = v);
    widget.onNotificationsChanged?.call(v);
  }
}

// ——— Reusable tiles & UI helpers ———

class _SliverSettingTile extends StatelessWidget {
  const _SliverSettingTile({
    required this.leadingBg,
    required this.leadingIcon,
    required this.onTap,
    required this.title,
    required this.subtitle,
  });

  final Color leadingBg;
  final IconData leadingIcon;
  final VoidCallback onTap;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  _LeadingIcon(bg: leadingBg, icon: leadingIcon),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
                              color: _SettingsColors.textDark,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            )),
                        const SizedBox(height: 2),
                        Text(subtitle,
                            style: const TextStyle(
                              color: _SettingsColors.textMuted,
                              fontSize: 13,
                            )),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      color: _SettingsColors.textMuted),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({
    required this.bg,
    required this.icon,
    this.iconColor = _SettingsColors.greenDark,
  });

  final Color bg;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Icon(icon, color: iconColor, size: 24),
    );
  }
}

class _PickerSheet extends StatelessWidget {
  const _PickerSheet({
    required this.title,
    required this.options,
    required this.initial,
  });

  final String title;
  final List<String> options;
  final String initial;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _SettingsColors.textDark,
                  fontSize: 16,
                )),
            const SizedBox(height: 12),
            ...options.map((o) => _PickerOption(
                  text: o,
                  selected: o == initial,
                  onTap: () => Navigator.pop(context, o),
                )),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class _PickerOption extends StatelessWidget {
  const _PickerOption({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(
        text,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: _SettingsColors.textDark,
        ),
      ),
      trailing: selected
          ? const Icon(Icons.check_circle, color: _SettingsColors.greenDark)
          : null,
      onTap: onTap,
    );
  }
}

class _SettingsColors {
  static const textDark = Color(0xFF333333);
  static const textMuted = Color(0xFF666666);
  static const greenDark = Color(0xFF6BAA75);
}
