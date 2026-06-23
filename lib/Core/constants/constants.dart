import 'package:flutter/material.dart';
import 'package:habit_tracker/Core/themes/app_themes.dart';
import 'package:habit_tracker/Features/finance/finance_model.dart';

const currencySymbol = "৳";

const expenseCategories = [
  CategoryOption('Food', Palette.clay, Icons.local_cafe_rounded),
  CategoryOption(
      'Transport', Palette.slate, Icons.directions_bus_filled_rounded),
  CategoryOption('Wellness', Palette.sage, Icons.spa_rounded),
  CategoryOption('Shopping', Palette.gold, Icons.shopping_bag_rounded),
  CategoryOption('Misc', Palette.muted, Icons.receipt_long_rounded),
];

const incomeCategories = [
  CategoryOption('Salary', Palette.teal, Icons.account_balance_wallet_rounded),
  CategoryOption('Freelance', Palette.slate, Icons.work_outline_rounded),
  CategoryOption('Gift', Palette.clay, Icons.card_giftcard_rounded),
  CategoryOption('Other', Palette.muted, Icons.savings_rounded),
];

InputDecoration decoration(
  Color isAccent, {
  String? hint,
  String? prefixText,
}) {
  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );
  return InputDecoration(
    hintText: hint,
    prefixText: prefixText,
    prefixStyle:
        const TextStyle(fontWeight: FontWeight.w700, color: Palette.ink),
    filled: true,
    fillColor: Palette.surface,
    border: border(Palette.hairline),
    enabledBorder: border(Palette.hairline),
    focusedBorder: border(isAccent, 1.6),
    errorBorder: border(Colors.redAccent.shade100),
    focusedErrorBorder: border(Colors.redAccent, 1.6),
  );
}
