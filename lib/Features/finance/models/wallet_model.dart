import 'package:habit_tracker/Features/finance/wallet_constants.dart';

// ─────────────────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────────────────

class WalletEntry {
  WalletEntry({
    required this.title,
    required this.amount,
    required this.categoryLabel,
    required this.date,
    this.note,
  });

  final String title;

  /// Positive = income, negative = expense.
  final double amount;

  final String categoryLabel;
  final DateTime date;
  final String? note;

  bool get isIncome => amount > 0;
  WalletCategory get category => categoryByLabel(categoryLabel);
}

// ─────────────────────────────────────────────────────────
// Date / time helpers — single source so both screens
// always display the same format.
// ─────────────────────────────────────────────────────────

String dayLabel(DateTime date) {
  final now = DateTime.now();
  final d = DateTime(date.year, date.month, date.day);
  final today = DateTime(now.year, now.month, now.day);
  final diff = today.difference(d).inDays;

  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';

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
  return '${date.day} ${months[date.month - 1]}';
}

String timeLabel(DateTime date) {
  final period = date.hour >= 12 ? 'PM' : 'AM';
  var h = date.hour % 12;
  if (h == 0) h = 12;
  final m = date.minute.toString().padLeft(2, '0');
  return '$h:$m $period';
}

String fullDateLabel(DateTime date) => '${dayLabel(date)} · ${timeLabel(date)}';
