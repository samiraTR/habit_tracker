import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:habit_tracker/Core/themes/app_themes.dart';

class CategorySpend {
  const CategorySpend({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  final String label;
  final double amount;
  final Color color;
  final IconData icon;
}

class WalletTransaction {
  const WalletTransaction({
    required this.title,
    required this.time,
    required this.day,
    required this.amount,
    required this.icon,
    required this.color,
  });

  final String title;
  final String time;
  final String day;
  final double amount; // positive = income, negative = expense
  final IconData icon;
  final Color color;
}

class FinanceWalletScreen extends StatelessWidget {
  FinanceWalletScreen({super.key});

  // ---- Source data --------------------------------------------------
  // Everything below is the single source of truth. Percentages, totals
  // and progress bars are all derived from these values rather than
  // hard-coded, so the UI can never silently drift out of sync with the
  // numbers it's supposed to represent.

  final double _balance = 1280;
  final double _balanceTrendPercent = 12;
  final double _income = 180;
  final double _budgetLimit = 140;

  final List<CategorySpend> _categories = const [
    CategorySpend(
      label: 'Food',
      amount: 45,
      color: Palette.clay,
      icon: Icons.local_cafe_rounded,
    ),
    CategorySpend(
      label: 'Transport',
      amount: 18,
      color: Palette.slate,
      icon: Icons.directions_bus_filled_rounded,
    ),
    CategorySpend(
      label: 'Wellness',
      amount: 30,
      color: Palette.sage,
      icon: Icons.spa_rounded,
    ),
  ];

  final List<WalletTransaction> _transactions = const [
    WalletTransaction(
      title: 'Coffee & notes',
      time: '10:45 AM',
      day: 'Today',
      amount: -8,
      icon: Icons.local_cafe_rounded,
      color: Palette.clay,
    ),
    WalletTransaction(
      title: 'Salary top-up',
      time: '8:20 AM',
      day: 'Today',
      amount: 180,
      icon: Icons.account_balance_wallet_rounded,
      color: Palette.teal,
    ),
    WalletTransaction(
      title: 'Yoga class',
      time: '6:00 PM',
      day: 'Yesterday',
      amount: -16,
      icon: Icons.spa_rounded,
      color: Palette.sage,
    ),
  ];

  double get _totalSpent => _categories.fold(0.0, (sum, c) => sum + c.amount);

  Map<String, List<WalletTransaction>> get _transactionsByDay {
    final map = <String, List<WalletTransaction>>{};
    for (final t in _transactions) {
      map.putIfAbsent(t.day, () => []).add(t);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final groupedDays = _transactionsByDay;

    return Scaffold(
      backgroundColor: Palette.bg,
      appBar: AppBar(
        backgroundColor: Palette.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Wallet',
          style: TextStyle(fontWeight: FontWeight.w800, color: Palette.ink),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded,
                color: Palette.ink),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Palette.teal,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add a transaction')),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 100),
          children: [
            _BalanceHero(
              balance: _balance,
              trendPercent: _balanceTrendPercent,
              income: _income,
              spent: _totalSpent,
            ),
            const SizedBox(height: 28),
            const _SectionLabel('Spending overview'),
            const SizedBox(height: 14),
            _SpendingCard(
              categories: _categories,
              totalSpent: _totalSpent,
              budgetLimit: _budgetLimit,
            ),
            const SizedBox(height: 28),
            const _SectionLabel('Recent activity'),
            const SizedBox(height: 14),
            for (final day in groupedDays.keys) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 4),
                child: Text(
                  day,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: Palette.muted,
                  ),
                ),
              ),
              _TransactionGroup(transactions: groupedDays[day]!),
              const SizedBox(height: 18),
            ],
          ],
        ),
      ),
    );
  }
}

/// Small uppercase eyebrow label used to introduce each section — the
/// grouping it sits above genuinely is a distinct category of content,
/// so the label is doing real structural work, not just decoration.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.4,
        color: Palette.muted,
      ),
    );
  }
}

/// The hero card: balance, trend, and an at-a-glance income/spent split,
/// all visible without scrolling.
class _BalanceHero extends StatelessWidget {
  const _BalanceHero({
    required this.balance,
    required this.trendPercent,
    required this.income,
    required this.spent,
  });

  final double balance;
  final double trendPercent;
  final double income;
  final double spent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Palette.teal, Palette.tealDark],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Palette.teal.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -16,
            top: -16,
            child: Icon(
              Icons.account_balance_wallet_rounded,
              size: 120,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total balance',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${balance.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.arrow_upward_rounded,
                              size: 13, color: Colors.white),
                          const SizedBox(width: 2),
                          Text(
                            '${trendPercent.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'this month',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6), fontSize: 13),
              ),
              const SizedBox(height: 20),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.16)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _HeroStat(
                      icon: Icons.call_received_rounded,
                      label: 'Income',
                      amount: income,
                      positive: true,
                    ),
                  ),
                  Container(
                      width: 1,
                      height: 36,
                      color: Colors.white.withValues(alpha: 0.16)),
                  Expanded(
                    child: _HeroStat(
                      icon: Icons.call_made_rounded,
                      label: 'Spent',
                      amount: spent,
                      positive: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.icon,
    required this.label,
    required this.amount,
    required this.positive,
  });

  final IconData icon;
  final String label;
  final double amount;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65), fontSize: 12),
              ),
              Text(
                '${positive ? '+' : '-'}\$${amount.toStringAsFixed(0)}',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Budget ring + category breakdown, sharing one card so the percentage
/// in the middle and the bars underneath always agree with each other.
class _SpendingCard extends StatelessWidget {
  const _SpendingCard({
    required this.categories,
    required this.totalSpent,
    required this.budgetLimit,
  });

  final List<CategorySpend> categories;
  final double totalSpent;
  final double budgetLimit;

  @override
  Widget build(BuildContext context) {
    final usedFraction =
        budgetLimit <= 0 ? 0.0 : (totalSpent / budgetLimit).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Palette.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              final animatedPercent = (usedFraction * value * 100).round();
              return SizedBox(
                width: 168,
                height: 168,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(168, 168),
                      painter: _BudgetRingPainter(
                        categories: categories,
                        totalSpent: totalSpent,
                        budgetLimit: budgetLimit,
                        progress: value,
                        trackColor: Palette.hairline,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$animatedPercent%',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Palette.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'of \$${budgetLimit.toStringAsFixed(0)} budget',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12, color: Palette.muted),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              for (var i = 0; i < categories.length; i++) ...[
                _CategoryRow(
                  category: categories[i],
                  share:
                      totalSpent <= 0 ? 0.0 : categories[i].amount / totalSpent,
                ),
                if (i != categories.length - 1) const SizedBox(height: 14),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Multi-segment ring: the filled portion represents budget used, and
/// each category's slice of that portion is proportional to its actual
/// share of spending — so the ring and the rows beneath it can never
/// tell two different stories.
class _BudgetRingPainter extends CustomPainter {
  _BudgetRingPainter({
    required this.categories,
    required this.totalSpent,
    required this.budgetLimit,
    required this.progress,
    required this.trackColor,
  });

  final List<CategorySpend> categories;
  final double totalSpent;
  final double budgetLimit;
  final double progress;
  final Color trackColor;

  static const double _strokeWidth = 14;
  static const double _gapRadians = 0.05;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - _strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    if (totalSpent <= 0 || budgetLimit <= 0) return;

    final usedFraction = (totalSpent / budgetLimit).clamp(0.0, 1.0);
    final totalSweep = 2 * math.pi * usedFraction * progress;

    double startAngle = -math.pi / 2;
    for (final category in categories) {
      final share = category.amount / totalSpent;
      final rawSweep = totalSweep * share;
      final sweep = (rawSweep - _gapRadians).clamp(0.0, rawSweep);

      if (sweep > 0) {
        final segmentPaint = Paint()
          ..color = category.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = _strokeWidth
          ..strokeCap = StrokeCap.round;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweep,
          false,
          segmentPaint,
        );
      }
      startAngle += rawSweep;
    }
  }

  @override
  bool shouldRepaint(covariant _BudgetRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.totalSpent != totalSpent ||
        oldDelegate.budgetLimit != budgetLimit;
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category, required this.share});

  final CategorySpend category;
  final double share;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: category.color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(category.icon, color: category.color, size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category.label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: Palette.ink),
                  ),
                  Text(
                    '\$${category.amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Palette.ink,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: share,
                  minHeight: 6,
                  backgroundColor: Palette.hairline,
                  valueColor: AlwaysStoppedAnimation(category.color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One rounded card per day, with hairline dividers between rows instead
/// of stacking a heavy shadowed card per transaction — quieter, and it
/// reads the grouping (same day) as one connected list rather than three
/// unrelated boxes.
class _TransactionGroup extends StatelessWidget {
  const _TransactionGroup({required this.transactions});
  final List<WalletTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < transactions.length; i++) ...[
            _TransactionTile(transaction: transactions[i]),
            if (i != transactions.length - 1)
              const Divider(
                  height: 1,
                  indent: 68,
                  endIndent: 16,
                  color: Palette.hairline),
          ],
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});
  final WalletTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.amount > 0;
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: transaction.color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(transaction.icon, color: transaction.color, size: 19),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: Palette.ink),
                ),
                const SizedBox(height: 3),
                Text(
                  transaction.time,
                  style: const TextStyle(color: Palette.muted, fontSize: 12.5),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}\$${transaction.amount.abs().toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: isIncome ? Palette.teal : Palette.ink,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
