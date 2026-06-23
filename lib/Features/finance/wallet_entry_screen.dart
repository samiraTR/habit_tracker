import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/Core/constants/constants.dart';
import 'package:habit_tracker/Features/finance/controllers/wallet_entry_controller.dart';
import 'package:habit_tracker/Features/finance/models/wallet_model.dart';

import 'wallet_constants.dart';

class WalletEntryScreen extends StatelessWidget {
  WalletEntryScreen({super.key});
  bool isNote = false;

  final _formKey = GlobalKey<FormState>();

  // Scoped to this route — disposed automatically when the screen is popped.
  final WalletEntryController ctrl = Get.put(WalletEntryController());

  // ── Date / time picker ────────────────────────────────────

  Future<void> _pickDateTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: ctrl.selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;
    if (!context.mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: ctrl.selectedTime.value,
    );
    if (pickedTime == null) return;

    ctrl.setDate(pickedDate);
    ctrl.setTime(pickedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WalletPalette.bg,
      appBar: AppBar(
        backgroundColor: WalletPalette.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: WalletPalette.ink),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'New entry',
          style:
              TextStyle(fontWeight: FontWeight.w800, color: WalletPalette.ink),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final accent = ctrl.accent;
          // final categories = ctrl.categories;
          final selectedCat = ctrl.selectedCategory;
          final dateStr = fullDateLabel(ctrl.combinedDateTime);

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Type toggle ─────────────────────────────
                  _TypeToggle(
                      isExpense: ctrl.isExpense.value, onChanged: ctrl.setType),
                  const SizedBox(height: 16),

                  // ── Live preview ────────────────────────────
                  _LivePreview(
                    isExpense: ctrl.isExpense.value,
                    accent: accent,
                    category: selectedCat,
                    amountCtrl: ctrl.amountCtrl,
                    titleCtrl: ctrl.titleCtrl,
                    dateLabel: dateStr,
                  ),
                  const SizedBox(height: 26),

                  Row(
                    children: [
                      // ── Title ───────────────────────────────────
                      Expanded(
                        flex: 2,
                        child: buildEntryForm('Title', accent, context),
                      ),

                      const SizedBox(width: 10),
                      // ── Amount ──────────────────────────────────

                      Expanded(
                        flex: 1,
                        child: buildEntryForm('Amount', accent, context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                          child: buildEntryForm('Category', accent, context)),
                      const SizedBox(width: 10),
                      Expanded(
                          child:
                              buildEntryForm("Date & time", accent, context)),
                    ],
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: ctrl.addNote,
                      child: const Text("Add Note"),
                    ),
                  ),

                  // ── Note ────────────────────────────────────
                  ctrl.isNote.value
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _FieldLabel('Note (optional)'),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: ctrl.noteCtrl,
                              maxLines: 3,
                              maxLength: 140,
                              decoration: decoration(accent,
                                  hint: 'Add any extra detail...'),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 12),

                  // ── Save button ─────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => ctrl.save(_formKey),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        ctrl.isExpense.value ? 'Save expense' : 'Save income',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Column buildEntryForm(String title, Color accent, BuildContext buildContext) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _FieldLabel(title),
      const SizedBox(height: 8),
      titleWidget(title, accent, buildContext),
    ]);
  }

  Widget titleWidget(String title, Color accent, BuildContext context) {
    switch (title) {
      case 'Category':
        return DropdownButtonFormField<String>(
          value: ctrl.category.value,
          decoration: decoration(accent),
          items: ctrl.categories.map((c) {
            return DropdownMenuItem(
              value: c.label,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: c.color.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(c.icon, size: 12, color: c.color),
                  ),
                  const SizedBox(width: 10),
                  Text(c.label),
                ],
              ),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) ctrl.setCategory(v);
          },
        );

      case 'Date & time':
        return Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _pickDateTime(context),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: WalletPalette.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: WalletPalette.hairline),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          fullDateLabel(ctrl.combinedDateTime),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: WalletPalette.ink,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.event_rounded, color: accent, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            // const SizedBox(width: 10),
            // SizedBox(
            //   height: 52,
            //   child: OutlinedButton(
            //     style: OutlinedButton.styleFrom(
            //       foregroundColor: accent,
            //       side: const BorderSide(color: WalletPalette.hairline),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(14),
            //       ),
            //       backgroundColor: WalletPalette.surface,
            //     ),
            //     onPressed: ctrl.resetToNow,
            //     child: const Text(
            //       'Now',
            //       style: TextStyle(fontWeight: FontWeight.w700),
            //     ),
            //   ),
            // ),
          ],
        );
      default:
        return TextFormField(
          controller: title == "Amount" ? ctrl.amountCtrl : ctrl.titleCtrl,
          keyboardType: title == "Amount"
              ? const TextInputType.numberWithOptions(decimal: true)
              : null,
          inputFormatters: title == "Amount"
              ? [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ]
              : [],
          style: title == "Amount"
              ? const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: WalletPalette.ink,
                )
              : const TextStyle(),
          decoration: title == "Amount"
              ? decoration(accent, hint: '0.00', prefixText: "$currencySymbol ")
              : decoration(accent, hint: 'e.g. Coffee with a client'),
          validator: (v) {
            if (title == "Amount") {
              final cleaned = v?.replaceAll(',', '').trim() ?? '';
              if (cleaned.isEmpty) return 'Enter an amount';
              final parsed = double.tryParse(cleaned);
              if (parsed == null) return 'Enter a valid number';
              if (parsed <= 0) return 'Amount must be greater than zero';
              return null;
            } else {
              if (v == null || v.trim().isEmpty) {
                return "Enter a title";
              } else {
                return null;
              }
            }
          },
        );
    }
  }
}

// ─────────────────────────────────────────────────────────
// Field label
// ─────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.1,
        color: WalletPalette.muted,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Type toggle
// ─────────────────────────────────────────────────────────

class _TypeToggle extends StatelessWidget {
  const _TypeToggle({required this.isExpense, required this.onChanged});
  final bool isExpense;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: WalletPalette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WalletPalette.hairline),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Segment(
              label: 'Expense',
              icon: Icons.call_made_rounded,
              color: WalletPalette.clay,
              selected: isExpense,
              onTap: () => onChanged(true),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _Segment(
              label: 'Income',
              icon: Icons.call_received_rounded,
              color: WalletPalette.teal,
              selected: !isExpense,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: selected ? color : WalletPalette.muted),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: selected ? color : WalletPalette.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Live preview card
// ─────────────────────────────────────────────────────────

class _LivePreview extends StatelessWidget {
  const _LivePreview({
    required this.isExpense,
    required this.accent,
    required this.category,
    required this.amountCtrl,
    required this.titleCtrl,
    required this.dateLabel,
  });

  final bool isExpense;
  final Color accent;
  final WalletCategory category;
  final TextEditingController amountCtrl;
  final TextEditingController titleCtrl;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([amountCtrl, titleCtrl]),
      builder: (context, _) {
        final raw = double.tryParse(amountCtrl.text.replaceAll(',', '').trim());
        final display = raw == null ? '0.00' : raw.toStringAsFixed(2);
        final title =
            titleCtrl.text.trim().isEmpty ? 'New entry' : titleCtrl.text.trim();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: WalletPalette.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: WalletPalette.hairline),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(category.icon, color: category.color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: WalletPalette.ink,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${category.label} · $dateLabel',
                      style: const TextStyle(
                        fontSize: 12,
                        color: WalletPalette.muted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${isExpense ? '-' : '+'}\$$display',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: accent,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
