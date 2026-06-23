import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/Features/finance/controllers/wallet_controller.dart';
import 'package:habit_tracker/Features/finance/models/wallet_model.dart';
import 'package:habit_tracker/Features/finance/wallet_constants.dart';

// import 'wallet_constants.dart';
// import 'wallet_controller.dart';
// import 'wallet_model.dart';

class WalletEntryController extends GetxController {
  // ── Form controllers ─────────────────────────────────────

  final TextEditingController amountCtrl = TextEditingController();
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController noteCtrl = TextEditingController();

  // ── Observable state ─────────────────────────────────────

  final RxBool isExpense = true.obs;
  final RxBool isNote = false.obs;
  final RxString category = expenseCategories.first.label.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<TimeOfDay> selectedTime = TimeOfDay.fromDateTime(DateTime.now()).obs;

  // ── Derived helpers ──────────────────────────────────────

  List<WalletCategory> get categories =>
      isExpense.value ? expenseCategories : incomeCategories;

  Color get accent => isExpense.value ? WalletPalette.clay : WalletPalette.teal;

  DateTime get combinedDateTime => DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        selectedTime.value.hour,
        selectedTime.value.minute,
      );

  WalletCategory get selectedCategory => categoryByLabel(category.value);

  // ── Actions ──────────────────────────────────────────────

  void setType(bool expense) {
    if (isExpense.value == expense) return;
    isExpense.value = expense;
    // Reset category when the list changes so the value always exists.
    if (!categories.any((c) => c.label == category.value)) {
      category.value = categories.first.label;
    }
  }

  Future<T?> showWalletDialog<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible,
    );
  }

  void addNote() => isNote.value = !isNote.value;
  void setCategory(String label) => category.value = label;

  void setDate(DateTime date) => selectedDate.value = date;
  void setTime(TimeOfDay time) => selectedTime.value = time;

  void resetToNow() {
    final now = DateTime.now();
    selectedDate.value = now;
    selectedTime.value = TimeOfDay.fromDateTime(now);
  }

  /// Validates, builds the entry, and hands it to WalletController.
  /// Returns true if the save succeeded.
  bool save(GlobalKey<FormState> formKey) {
    if (!(formKey.currentState?.validate() ?? false)) return false;

    final cleaned = amountCtrl.text.replaceAll(',', '').trim();
    final parsed = double.parse(cleaned);
    final signed = isExpense.value ? -parsed : parsed;

    Get.find<WalletController>().addEntry(
      WalletEntry(
        title: titleCtrl.text.trim(),
        amount: signed,
        categoryLabel: category.value,
        date: combinedDateTime,
        note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
      ),
    );
    return true;
  }

  // ── Lifecycle ────────────────────────────────────────────

  @override
  void onClose() {
    amountCtrl.dispose();
    titleCtrl.dispose();
    noteCtrl.dispose();
    super.onClose();
  }
}
