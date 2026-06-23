import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/Core/routes/app_routes.dart';
import 'package:habit_tracker/Features/day_planner/day_planner_screen.dart';
import 'package:habit_tracker/Features/finance/controllers/wallet_controller.dart';
import 'package:habit_tracker/Features/finance/wallet_constants.dart';
import 'package:habit_tracker/Features/goal_tracker/goals_tracker_screen.dart';
import 'package:habit_tracker/Features/finance/finance_wallet_screen.dart';
import 'package:habit_tracker/Features/others/widgets/notice_slide_show.dart';
import 'package:habit_tracker/Features/routine/routine_screen.dart';
import 'package:intl/intl.dart';

// ─────────────────────────────────────────────────────────
// Dashboard (shell)
// ─────────────────────────────────────────────────────────

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // WalletController is registered here once and shared with every
  // screen that needs wallet data via Get.find<WalletController>().
  final WalletController _walletCtrl = Get.put(WalletController());

  late final List<Widget> _pages = [
    const DashboardOverviewScreen(),
    const DayPlannerScreen(),
    const GoalsTrackerScreen(),
    FinanceWalletScreen(),
  ];

  void _openQuickAddSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create new',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add a new task, habit, goal, journal note or vision item.',
              style: TextStyle(color: Color(0xFF6E7DA7), height: 1.5),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildQuickAction('Task', Icons.schedule_rounded,
                    () => Get.toNamed(AppRoutes.walletEntry)),
                _buildQuickAction('Routine', Icons.checklist_rtl_rounded,
                    () => Get.toNamed(AppRoutes.walletEntry)),
                _buildQuickAction('Goal', Icons.flag_rounded,
                    () => Get.toNamed(AppRoutes.walletEntry)),
                _buildQuickAction('Journal', Icons.edit_rounded,
                    () => Get.toNamed(AppRoutes.walletEntry)),
                _buildQuickAction('Vision', Icons.image_rounded,
                    () => Get.toNamed(AppRoutes.walletEntry)),
                _buildQuickAction('Finance', Icons.credit_card_outlined,
                    () => Get.toNamed(AppRoutes.walletEntry)),
              ],
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop(); // close sheet first
        onTap();
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FF),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF7C77F2), size: 24),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _selectedIndex = 0);
      },
      child: Scaffold(
        body: _pages[_selectedIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: _openQuickAddSheet,
          backgroundColor: const Color(0xFF7C77F2),
          child: const Icon(Icons.add, size: 28),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          elevation: 14,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(Icons.home_rounded, 'Overview', 0),
              _buildNavItem(Icons.view_day_rounded, 'Planner', 1),
              const SizedBox(width: 56),
              _buildNavItem(Icons.flag_rounded, 'Goals', 2),
              _buildNavItem(Icons.account_balance_wallet_rounded, 'Wallet', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = _selectedIndex == index;
    final color = isActive ? const Color(0xFF7C77F2) : const Color(0xFF9FA8C8);
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEEF2FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Overview page
// ─────────────────────────────────────────────────────────

class DashboardOverviewScreen extends StatelessWidget {
  const DashboardOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Reads the same controller registered by DashboardScreen.
    final walletCtrl = Get.find<WalletController>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ──────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back,',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF5F6E8A)),
                      ),
                      Text(
                        DateFormat.yMMMMEEEEd().format(DateTime.now()),
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF5F6E8A)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Balance pill — live from WalletController
                Obx(() => InkWell(
                      onTap: () => Get.toNamed(AppRoutes.financeWallet),
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF7C77F2).withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor: const Color(0xFF7C77F2)
                                  .withValues(alpha: 0.16),
                              child: const Icon(
                                Icons.account_balance_wallet_rounded,
                                size: 16,
                                color: Color(0xFF7C77F2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '\$${walletCtrl.balance.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF7C77F2),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Your productivity hub',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800, height: 1.1),
            ),
            const SizedBox(height: 18),

            // ── Summary cards ───────────────────────────────
            Row(
              children: [
                Expanded(
                    child: _buildSummaryCard('Tasks', 'target', '4/5', '')),
                const SizedBox(width: 14),
                Expanded(
                    child: _buildSummaryCard('Streak', 'fire', '2 days', '')),
                const SizedBox(width: 14),
                Expanded(
                    child:
                        _buildSummaryCard('Mood', 'smiling-face', 'Good', '')),
              ],
            ),

            // ── Today's schedule ────────────────────────────
            _buildTitleRow("Today's schedule", () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DayPlannerScreen()));
            }),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 18,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
                child: Row(
                  children: [
                    Expanded(
                      flex: 0,
                      child: Text('9:00 AM',
                          style: TextStyle(
                              fontSize: 14.3, fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Text('Morning routine',
                          style: TextStyle(
                              fontSize: 14.6, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ),

            // ── Routines ────────────────────────────────────
            _buildTitleRow('Routines', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RoutineScreen()));
            }),
            const SizedBox(height: 22),

            // ── Today's focus ───────────────────────────────
            const _SectionHeader(title: "Today's focus"),
            const SizedBox(height: 12),
            NoticeSlideshow(),
            const SizedBox(height: 22),

            // ── Progress overview ───────────────────────────
            const _SectionHeader(title: 'Progress overview'),
            const SizedBox(height: 12),
            _buildProgressTile(
              'Routines on track',
              '12 of 14 habits completed this week.',
              0.86,
            ),
            const SizedBox(height: 12),

            // Finance snapshot — live fraction from WalletController
            Obx(() {
              final fraction = walletCtrl.budgetFraction;
              final spent = walletCtrl.totalSpent;
              final budget = kMonthlyBudget;
              return _buildProgressTile(
                'Finance snapshot',
                '\$${spent.toStringAsFixed(0)} of \$${budget.toStringAsFixed(0)} budget used this month.',
                fraction,
                color: fraction >= 0.9
                    ? const Color(0xFFC76F4D) // over budget — clay warning
                    : const Color(0xFF7C77F2),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Row _buildTitleRow(String title, VoidCallback onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        TextButton(onPressed: onViewAll, child: const Text('View All')),
      ],
    );
  }

  Widget _buildSummaryCard(
      String title, String iconName, String amount, String caption) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 18,
              offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF7B8CB5))),
              const SizedBox(width: 6),
              Image.asset('assets/images/$iconName.png', width: 16, height: 16),
            ],
          ),
          Text(amount,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildProgressTile(
    String title,
    String subtitle,
    double value, {
    Color color = const Color(0xFF7C77F2),
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 18,
              offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              Text(
                '${(value * 100).round()}%',
                style: TextStyle(color: color, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(subtitle,
              style: const TextStyle(color: Color(0xFF7B8CB5), height: 1.5)),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              color: color,
              backgroundColor: const Color(0xFFE9EEFF),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        Text(
          'View all',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
