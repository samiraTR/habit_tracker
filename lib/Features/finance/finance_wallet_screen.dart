import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/Core/constants/constants.dart';
import 'package:habit_tracker/Features/finance/controllers/wallet_controller.dart';
import 'package:habit_tracker/Features/finance/models/wallet_model.dart';

import 'wallet_constants.dart';

// ─────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────

class FinanceWalletScreen extends StatelessWidget {
  const FinanceWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // WalletController is already registered by DashboardScreen.
    final ctrl = Get.find<WalletController>();

    

    return Scaffold(
      backgroundColor: WalletPalette.bg,
      appBar: AppBar(
        backgroundColor: WalletPalette.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Wallet',
          style:
              TextStyle(fontWeight: FontWeight.w800, color: WalletPalette.ink),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.dialog(
                Dialog(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Set Your Budget Limit"),
                      Expanded(child: TextFormField())
                    ],
                  ),
                ),
              );
            },
            child: Image.asset(
              "assets/icons/accounting.png",
              height: 20,
              width: 20,
              scale: 10,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded,
                color: WalletPalette.ink),
            onPressed: () {},
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: WalletPalette.teal,
      //   onPressed: () => Get.toNamed('/walletEntry'),
      //   child: const Icon(Icons.add_rounded),
      // ),
      body: SafeArea(
        child: Obx(() {
          final breakdown = ctrl.expenseBreakdown;
          final groupedDays = ctrl.entriesByDay;

          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 100),
            children: [
              _BalanceHero(
                balance: ctrl.balance,
                income: ctrl.totalIncome,
                spent: ctrl.totalSpent,
              ),
              const SizedBox(height: 28),
              const _SectionLabel('Spending overview'),
              const SizedBox(height: 14),
              _SpendingCard(
                breakdown: breakdown,
                totalSpent: ctrl.totalSpent,
                budgetLimit: kMonthlyBudget,
              ),
              const SizedBox(height: 28),
              const _SectionLabel('Recent activity'),
              const SizedBox(height: 14),
              if (groupedDays.isEmpty)
                _EmptyActivity(onAdd: () => Get.toNamed('/walletEntry'))
              else
                for (final day in groupedDays.keys) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 4),
                    child: Text(
                      day,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: WalletPalette.muted,
                      ),
                    ),
                  ),
                  _TransactionGroup(transactions: groupedDays[day]!),
                  const SizedBox(height: 18),
                ],
            ],
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────────────────

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
        color: WalletPalette.muted,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Hero balance card
// ─────────────────────────────────────────────────────────

class _BalanceHero extends StatelessWidget {
  const _BalanceHero({
    required this.balance,
    required this.income,
    required this.spent,
  });

  final double balance;
  final double income;
  final double spent;

  @override
  Widget build(BuildContext context) {
    final net = income - spent;
    final isPositive = net >= 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [WalletPalette.teal, WalletPalette.tealDark],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: WalletPalette.teal.withValues(alpha: 0.28),
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
                    "$currencySymbol ${balance.toStringAsFixed(0)}",
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
                          Icon(
                            isPositive
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${isPositive ? '+' : '-'} $currencySymbol ${net.abs().toStringAsFixed(0)} net',
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
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
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
                    color: Colors.white.withValues(alpha: 0.16),
                  ),
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
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 12,
                ),
              ),
              Text(
                '${positive ? '+' : '-'} $currencySymbol ${amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Spending card with budget ring
// ─────────────────────────────────────────────────────────

class _SpendingCard extends StatelessWidget {
  const _SpendingCard({
    required this.breakdown,
    required this.totalSpent,
    required this.budgetLimit,
  });

  final List<MapEntry<WalletCategory, double>> breakdown;
  final double totalSpent;
  final double budgetLimit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WalletPalette.surface,
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
              final used = budgetLimit <= 0
                  ? 0.0
                  : (totalSpent / budgetLimit).clamp(0.0, 1.0);
              final pct = (used * value * 100).round();
              return SizedBox(
                width: 168,
                height: 168,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(168, 168),
                      painter: _BudgetRingPainter(
                        breakdown: breakdown,
                        totalSpent: totalSpent,
                        budgetLimit: budgetLimit,
                        progress: value,
                        trackColor: WalletPalette.hairline,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$pct%',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: WalletPalette.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'of $currencySymbol ${budgetLimit.toStringAsFixed(0)} budget',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: WalletPalette.muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          if (breakdown.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                'No expenses yet this month.',
                style: TextStyle(color: WalletPalette.muted),
              ),
            )
          else
            Column(
              children: [
                for (var i = 0; i < breakdown.length; i++) ...[
                  _CategoryRow(
                    category: breakdown[i].key,
                    amount: breakdown[i].value,
                    share:
                        totalSpent <= 0 ? 0.0 : breakdown[i].value / totalSpent,
                  ),
                  if (i != breakdown.length - 1) const SizedBox(height: 14),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _BudgetRingPainter extends CustomPainter {
  const _BudgetRingPainter({
    required this.breakdown,
    required this.totalSpent,
    required this.budgetLimit,
    required this.progress,
    required this.trackColor,
  });

  final List<MapEntry<WalletCategory, double>> breakdown;
  final double totalSpent;
  final double budgetLimit;
  final double progress;
  final Color trackColor;

  static const double _strokeWidth = 14;
  static const double _gap = 0.05;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - _strokeWidth) / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = _strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    if (totalSpent <= 0 || budgetLimit <= 0) return;

    final totalSweep =
        2 * math.pi * (totalSpent / budgetLimit).clamp(0.0, 1.0) * progress;
    var start = -math.pi / 2;

    for (final entry in breakdown) {
      final rawSweep = totalSweep * (entry.value / totalSpent);
      final sweep = (rawSweep - _gap).clamp(0.0, rawSweep);
      if (sweep > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          start,
          sweep,
          false,
          Paint()
            ..color = entry.key.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = _strokeWidth
            ..strokeCap = StrokeCap.round,
        );
      }
      start += rawSweep;
    }
  }

  @override
  bool shouldRepaint(covariant _BudgetRingPainter old) =>
      old.progress != progress ||
      old.totalSpent != totalSpent ||
      old.breakdown.length != breakdown.length;
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.category,
    required this.amount,
    required this.share,
  });

  final WalletCategory category;
  final double amount;
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
                      fontWeight: FontWeight.w700,
                      color: WalletPalette.ink,
                    ),
                  ),
                  Text(
                    '$currencySymbol' '${amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: WalletPalette.ink,
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
                  backgroundColor: WalletPalette.hairline,
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

// ─────────────────────────────────────────────────────────
// Transaction list
// ─────────────────────────────────────────────────────────

class _TransactionGroup extends StatelessWidget {
  const _TransactionGroup({required this.transactions});
  final List<WalletEntry> transactions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: WalletPalette.surface,
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
            _TransactionTile(entry: transactions[i]),
            if (i != transactions.length - 1)
              const Divider(
                height: 1,
                indent: 68,
                endIndent: 16,
                color: WalletPalette.hairline,
              ),
          ],
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.entry});
  final WalletEntry entry;

  @override
  Widget build(BuildContext context) {
    final cat = entry.category;
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cat.color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(cat.icon, color: cat.color, size: 19),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: WalletPalette.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  timeLabel(entry.date),
                  style: const TextStyle(
                    color: WalletPalette.muted,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${entry.isIncome ? '+' : '-'}\$${entry.amount.abs().toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: entry.isIncome ? WalletPalette.teal : WalletPalette.ink,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyActivity extends StatelessWidget {
  const _EmptyActivity({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: WalletPalette.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: WalletPalette.hairline),
        ),
        child: const Text(
          'No activity yet — tap + to add your first entry.',
          style: TextStyle(color: WalletPalette.muted),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
