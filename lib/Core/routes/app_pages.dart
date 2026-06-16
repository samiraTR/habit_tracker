import 'package:get/get.dart';
import 'package:habit_tracker/Core/routes/app_routes.dart';
import 'package:habit_tracker/Features/dashboard/dashboard.dart';
import 'package:habit_tracker/Features/finance/finance_wallet_screen.dart';
import 'package:habit_tracker/Features/finance/wallet_entry_screen.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.dashboard, page: () => const DashboardScreen()),
    GetPage(name: AppRoutes.financeWallet, page: () => FinanceWalletScreen()),
    GetPage(name: AppRoutes.walletEntry, page: () => const WalletEntryScreen())
  ];
}
