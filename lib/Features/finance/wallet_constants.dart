import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────
// Palette
// ─────────────────────────────────────────────────────────

class WalletPalette {
  WalletPalette._();

  static const Color bg = Color(0xFFF7F5F0);
  static const Color surface = Colors.white;
  static const Color ink = Color(0xFF1B1F2A);
  static const Color muted = Color(0xFF6F7785);
  static const Color hairline = Color(0xFFE9E4DA);
  static const Color teal = Color(0xFF2F6D5B);
  static const Color tealDark = Color(0xFF173C34);
  static const Color clay = Color(0xFFC76F4D);
  static const Color slate = Color(0xFF4F6D8C);
  static const Color sage = Color(0xFF7C9473);
  static const Color gold = Color(0xFFB08D57);
}

// ─────────────────────────────────────────────────────────
// Category model
// ─────────────────────────────────────────────────────────

class WalletCategory {
  const WalletCategory({
    required this.label,
    required this.color,
    required this.icon,
    required this.isExpense,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool isExpense;
}

// ─────────────────────────────────────────────────────────
// Category lists
// ─────────────────────────────────────────────────────────

const List<WalletCategory> expenseCategories = [
  WalletCategory(
    label: 'Food',
    color: WalletPalette.clay,
    icon: Icons.local_cafe_rounded,
    isExpense: true,
  ),
  WalletCategory(
    label: 'Transport',
    color: WalletPalette.slate,
    icon: Icons.directions_bus_filled_rounded,
    isExpense: true,
  ),
  WalletCategory(
    label: 'Wellness',
    color: WalletPalette.sage,
    icon: Icons.spa_rounded,
    isExpense: true,
  ),
  WalletCategory(
    label: 'Shopping',
    color: WalletPalette.gold,
    icon: Icons.shopping_bag_rounded,
    isExpense: true,
  ),
  WalletCategory(
    label: 'Misc',
    color: WalletPalette.muted,
    icon: Icons.receipt_long_rounded,
    isExpense: true,
  ),
];

const List<WalletCategory> incomeCategories = [
  WalletCategory(
    label: 'Salary',
    color: WalletPalette.teal,
    icon: Icons.account_balance_wallet_rounded,
    isExpense: false,
  ),
  WalletCategory(
    label: 'Freelance',
    color: WalletPalette.slate,
    icon: Icons.work_outline_rounded,
    isExpense: false,
  ),
  WalletCategory(
    label: 'Gift',
    color: WalletPalette.clay,
    icon: Icons.card_giftcard_rounded,
    isExpense: false,
  ),
  WalletCategory(
    label: 'Other',
    color: WalletPalette.muted,
    icon: Icons.savings_rounded,
    isExpense: false,
  ),
];

/// Resolves a category by label across both lists.
WalletCategory categoryByLabel(String label) {
  return [...expenseCategories, ...incomeCategories].firstWhere(
    (c) => c.label == label,
    orElse: () => expenseCategories.last,
  );
}

const double kMonthlyBudget = 0.0;
const double kOpeningBalance = 0.0;
