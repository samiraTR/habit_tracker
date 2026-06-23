import 'package:get/get.dart';
import 'package:habit_tracker/Features/finance/models/wallet_model.dart';
import 'package:habit_tracker/Features/finance/wallet_constants.dart';

class WalletController extends GetxController {
  // ── State ────────────────────────────────────────────────

  final RxList<WalletEntry> entries = <WalletEntry>[].obs;

  // ── Lifecycle ────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    // _seed();
  }

  void _seed() {
    final now = DateTime.now();
    DateTime at(int daysAgo, int hour, int minute) =>
        DateTime(now.year, now.month, now.day - daysAgo, hour, minute);

    entries.addAll([
      WalletEntry(
          title: 'Salary top-up',
          amount: 180,
          categoryLabel: 'Salary',
          date: at(0, 8, 20)),
      WalletEntry(
          title: 'Coffee & notes',
          amount: -8,
          categoryLabel: 'Food',
          date: at(0, 10, 45)),
      WalletEntry(
          title: 'Grocery run',
          amount: -37,
          categoryLabel: 'Food',
          date: at(0, 13, 30)),
      WalletEntry(
          title: 'Metro pass',
          amount: -18,
          categoryLabel: 'Transport',
          date: at(1, 9, 0)),
      WalletEntry(
          title: 'Yoga class',
          amount: -16,
          categoryLabel: 'Wellness',
          date: at(1, 18, 0)),
      WalletEntry(
          title: 'Spa session',
          amount: -14,
          categoryLabel: 'Wellness',
          date: at(2, 17, 0)),
    ]);
  }

  // ── Derived getters ──────────────────────────────────────

  /// Running balance: opening balance + every signed entry ever added.
  double get balance =>
      kOpeningBalance + entries.fold(0.0, (sum, e) => sum + e.amount);

  bool _isThisMonth(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month;
  }

  List<WalletEntry> get thisMonthEntries =>
      entries.where((e) => _isThisMonth(e.date)).toList();

  double get totalIncome => thisMonthEntries
      .where((e) => e.isIncome)
      .fold(0.0, (sum, e) => sum + e.amount);

  double get totalSpent => thisMonthEntries
      .where((e) => !e.isIncome)
      .fold(0.0, (sum, e) => sum - e.amount);

  /// 0.0 – 1.0 fraction of the monthly budget consumed.
  double get budgetFraction =>
      kMonthlyBudget <= 0 ? 0.0 : (totalSpent / kMonthlyBudget).clamp(0.0, 1.0);

  /// Expense totals grouped by category, sorted largest first.
  List<MapEntry<WalletCategory, double>> get expenseBreakdown {
    final totals = <String, double>{};
    for (final e in thisMonthEntries.where((e) => !e.isIncome)) {
      totals[e.categoryLabel] = (totals[e.categoryLabel] ?? 0) + (-e.amount);
    }
    final list = totals.entries
        .map((e) => MapEntry(categoryByLabel(e.key), e.value))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return list;
  }

  /// Most-recent-first sorted list for the activity feed.
  List<WalletEntry> get sortedEntries {
    final list = List<WalletEntry>.from(entries);
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  /// Entries grouped by day label (Today / Yesterday / date string).
  Map<String, List<WalletEntry>> get entriesByDay {
    final map = <String, List<WalletEntry>>{};
    for (final e in sortedEntries) {
      map.putIfAbsent(dayLabel(e.date), () => []).add(e);
    }
    return map;
  }

  // ── Mutations ────────────────────────────────────────────

  void addEntry(WalletEntry entry) => entries.add(entry);
}
