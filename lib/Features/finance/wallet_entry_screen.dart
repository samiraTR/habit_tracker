import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/Core/constants/constants.dart';
import 'package:habit_tracker/Core/routes/app_routes.dart';
import 'package:habit_tracker/Core/themes/app_themes.dart';

class _CategoryOption {
  const _CategoryOption(this.label, this.color, this.icon);
  final String label;
  final Color color;
  final IconData icon;
}

const _expenseCategories = [
  _CategoryOption('Food', Palette.clay, Icons.local_cafe_rounded),
  _CategoryOption(
      'Transport', Palette.slate, Icons.directions_bus_filled_rounded),
  _CategoryOption('Wellness', Palette.sage, Icons.spa_rounded),
  _CategoryOption('Shopping', Palette.gold, Icons.shopping_bag_rounded),
  _CategoryOption('Misc', Palette.muted, Icons.receipt_long_rounded),
];

const _incomeCategories = [
  _CategoryOption('Salary', Palette.teal, Icons.account_balance_wallet_rounded),
  _CategoryOption('Freelance', Palette.slate, Icons.work_outline_rounded),
  _CategoryOption('Gift', Palette.clay, Icons.card_giftcard_rounded),
  _CategoryOption('Other', Palette.muted, Icons.savings_rounded),
];

class WalletEntryScreen extends StatefulWidget {
  const WalletEntryScreen({super.key});

  @override
  State<WalletEntryScreen> createState() => _WalletEntryScreenState();
}

class _WalletEntryScreenState extends State<WalletEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  bool _isExpense = true;
  String _category = _expenseCategories.first.label;
  DateTime _selectedDate = DateTime.now();

  List<_CategoryOption> get _categories =>
      _isExpense ? _expenseCategories : _incomeCategories;

  Color get _accent => _isExpense ? Palette.clay : Palette.teal;

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _setEntryType(bool expense) {
    if (_isExpense == expense) return;
    setState(() {
      _isExpense = expense;
      // The category list changes with the type, so make sure whatever
      // was selected before still exists in the new list.
      if (!_categories.any((c) => c.label == _category)) {
        _category = _categories.first.label;
      }
    });
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _formatDate(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final label =
        '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
    return _isToday(date) ? 'Today · $label' : label;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveEntry() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${_isExpense ? 'Expense' : 'Income'} entry saved')),
      );
      Get.toNamed(AppRoutes.financeWallet);
    }
  }

  // InputDecoration decoration({String? hint, String? prefixText}) {
  //   OutlineInputBorder border(Color color, [double width = 1]) =>
  //       OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(14),
  //         borderSide: BorderSide(color: color, width: width),
  //       );
  //   return InputDecoration(
  //     hintText: hint,
  //     prefixText: prefixText,
  //     prefixStyle:
  //         const TextStyle(fontWeight: FontWeight.w700, color: Palette.ink),
  //     filled: true,
  //     fillColor: Palette.surface,
  //     border: border(Palette.hairline),
  //     enabledBorder: border(Palette.hairline),
  //     focusedBorder: border(_accent, 1.6),
  //     errorBorder: border(Colors.redAccent.shade100),
  //     focusedErrorBorder: border(Colors.redAccent, 1.6),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final selectedCategory =
        _categories.firstWhere((c) => c.label == _category);

    return Scaffold(
      backgroundColor: Palette.bg,
      appBar: AppBar(
        backgroundColor: Palette.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Palette.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'New entry',
          style: TextStyle(fontWeight: FontWeight.w800, color: Palette.ink),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type comes first: it decides the amount's sign and which
                // categories make sense, so everything below reacts to it.
                _TypeToggle(isExpense: _isExpense, onChanged: _setEntryType),
                const SizedBox(height: 16),
                _LivePreview(
                  isExpense: _isExpense,
                  accent: _accent,
                  category: selectedCategory,
                  amountListenable: _amountController,
                  titleListenable: _titleController,
                  dateLabel: _formatDate(_selectedDate),
                ),
                const SizedBox(height: 26),
                const _FieldLabel('Amount'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Palette.ink),
                  decoration:
                      decoration(_accent, hint: '0.00', prefixText: '\$ '),
                  validator: (value) {
                    final cleaned = value?.replaceAll(',', '').trim() ?? '';
                    if (cleaned.isEmpty) return 'Enter an amount';
                    final parsed = double.tryParse(cleaned);
                    if (parsed == null) return 'Enter a valid number';
                    if (parsed <= 0) return 'Amount must be greater than zero';
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const _FieldLabel('Title'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration:
                      decoration(_accent, hint: 'e.g. Coffee with a client'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const _FieldLabel('Category'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: decoration(_accent),
                  items: _categories.map((c) {
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
                  onChanged: (value) {
                    if (value != null) setState(() => _category = value);
                  },
                ),
                const SizedBox(height: 18),
                const _FieldLabel('Date'),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Palette.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Palette.hairline),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDate(_selectedDate),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Palette.ink),
                              ),
                              Icon(Icons.calendar_month_rounded,
                                  color: _accent, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (!_isToday(_selectedDate)) ...[
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 52,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Palette.surface,
                            foregroundColor: _accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: const BorderSide(color: Palette.hairline),
                            ),
                          ),
                          onPressed: () =>
                              setState(() => _selectedDate = DateTime.now()),
                          child: const Text('Today',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 18),
                const _FieldLabel('Note (optional)'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  maxLines: 3,
                  maxLength: 140,
                  decoration:
                      decoration(_accent, hint: 'Add any extra detail...'),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveEntry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      _isExpense ? 'Save expense' : 'Save income',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small uppercase label introducing each field — consistent with the
/// section labels on the wallet summary screen instead of relying on
/// Material's floating labelText.
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
        color: Palette.muted,
      ),
    );
  }
}

/// Expense/Income is a binary, mutually-exclusive choice, so a segmented
/// toggle is the right control for it — not a dropdown, which implies a
/// longer list of options the user has to read through.
class _TypeToggle extends StatelessWidget {
  const _TypeToggle({required this.isExpense, required this.onChanged});
  final bool isExpense;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Palette.hairline),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleSegment(
              label: 'Expense',
              icon: Icons.call_made_rounded,
              color: Palette.clay,
              selected: isExpense,
              onTap: () => onChanged(true),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _ToggleSegment(
              label: 'Income',
              icon: Icons.call_received_rounded,
              color: Palette.teal,
              selected: !isExpense,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleSegment extends StatelessWidget {
  const _ToggleSegment({
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
            Icon(icon, size: 16, color: selected ? color : Palette.muted),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: selected ? color : Palette.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Live summary card that updates as the user types, so the connection
/// between type, category, amount and date is visible immediately
/// instead of only appearing after the form is submitted.
class _LivePreview extends StatelessWidget {
  const _LivePreview({
    required this.isExpense,
    required this.accent,
    required this.category,
    required this.amountListenable,
    required this.titleListenable,
    required this.dateLabel,
  });

  final bool isExpense;
  final Color accent;
  final _CategoryOption category;
  final TextEditingController amountListenable;
  final TextEditingController titleListenable;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([amountListenable, titleListenable]),
      builder: (context, _) {
        final cleanedAmount = amountListenable.text.replaceAll(',', '').trim();
        final parsedAmount = double.tryParse(cleanedAmount);
        final displayAmount =
            parsedAmount == null ? '0.00' : parsedAmount.toStringAsFixed(2);
        final title = titleListenable.text.trim().isEmpty
            ? 'New entry'
            : titleListenable.text.trim();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Palette.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Palette.hairline),
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
                          fontWeight: FontWeight.w700, color: Palette.ink),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${category.label} · $dateLabel',
                      style:
                          const TextStyle(fontSize: 12, color: Palette.muted),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${isExpense ? '-' : '+'}\$$displayAmount',
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
