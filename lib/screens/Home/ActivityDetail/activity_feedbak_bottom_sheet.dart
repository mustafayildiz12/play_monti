// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:play_monti/constants/app_constants.dart';
import 'package:play_monti/constants/app_localization.dart';
import 'package:play_monti/models/feedback_model.dart';

import 'package:play_monti/models/final_activity_model.dart';
import 'package:play_monti/service/authentication_service.dart';
import 'package:play_monti/service/feedback_service.dart';
import 'package:play_monti/utlis/widgets/custom_snackbar.dart';

/// Geri dönüş tipi
enum FeedbackType { like, dislike }

/// BottomSheet sonucunda dönecek model
class FeedbackResult {
  final FeedbackType type;
  final String note;

  const FeedbackResult({required this.type, required this.note});
}

/// Asıl bottom sheet içeriği
class FeedbackBottomSheet extends StatefulWidget {
  const FeedbackBottomSheet({
    super.key,
    this.finalActivityModel,
  });
  final FinalActivityModel? finalActivityModel;

  @override
  State<FeedbackBottomSheet> createState() => FeedbackBottomSheetState();
}

class FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  FeedbackType? _selected;
  final TextEditingController _noteCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  void _select(FeedbackType t) {
    HapticFeedback.lightImpact();
    setState(() => _selected = t);
  }

  Future<void> _submit() async {
    if (_selected == null) {
      HapticFeedback.selectionClick();
      customSnackBar.warning('Lütfen beğeni durumunu seçin.');
      return;
    }
    setState(() => _sending = true);

    if (widget.finalActivityModel != null) {
      final feedbackmodel = ActivityFeedbackModel(
          userEmail: currentMontiUser?.userEmail ?? "",
          userId: authenticationService.getUser()!.uid,
          userName: currentMontiUser!.userName ?? "",
          feedbackText: _noteCtrl.text.trim(),
          isLiked: _selected == FeedbackType.dislike ? 0 : 1,
          activityId: widget.finalActivityModel!.day,
          activityGroup: widget.finalActivityModel!.ageGroup,
          language: AppLocalization.currentLangCode,
          createDate: DateTime.now().toIso8601String());

      await feedbackService.addActivityFeedback(feedbackmodel: feedbackmodel);
    } else {
      await feedbackService.addAppFeedback(
        isLiked: _selected == FeedbackType.dislike ? 0 : 1,
        feedbackText: _noteCtrl.text.trim(),
      );
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Geri bildiriminiz için teşekkür ederiz.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets; // klavye
    final theme = Theme.of(context);

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: theme.colorScheme.surface,
          elevation: 12,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Başlık
                  Row(
                    children: [
                      Text(
                        'Geri Bildirim',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Kapat',
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Like / Dislike butonları
                  Row(
                    children: [
                      _ChoiceChip(
                        label: 'Beğendim',
                        icon: Icons.thumb_up_alt_rounded,
                        selected: _selected == FeedbackType.like,
                        onTap: () => _select(FeedbackType.like),
                      ),
                      const SizedBox(width: 12),
                      _ChoiceChip(
                        label: 'Beğenmedim',
                        icon: Icons.thumb_down_alt_rounded,
                        selected: _selected == FeedbackType.dislike,
                        onTap: () => _select(FeedbackType.dislike),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Açıklama alanı
                  TextField(
                    controller: _noteCtrl,
                    maxLines: 5,
                    minLines: 3,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      labelText: 'Açıklama (opsiyonel)',
                      hintText: 'Düşüncelerini kısaca yaz...',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Karakter sayacı (küçük ipucu)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${_noteCtrl.text.characters.length} karakter',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.hintColor),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Butonlar
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _sending
                              ? null
                              : () => Navigator.of(context).maybePop(),
                          child: const Text('Vazgeç'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _sending ? null : _submit,
                          icon: _sending
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.send_rounded),
                          label: const Text('Gönder'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Like/Dislike için şık bir chip buton
class _ChoiceChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selBg = theme.colorScheme.primary.withOpacity(0.12);
    final selFg = theme.colorScheme.primary;
    final unSelBg = theme.colorScheme.surfaceContainerHighest;
    final unSelFg = theme.colorScheme.onSurface;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? selBg : unSelBg,
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.dividerColor.withOpacity(0.4),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: selected ? selFg : unSelFg),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: selected ? selFg : unSelFg,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
