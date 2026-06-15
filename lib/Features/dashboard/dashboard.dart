import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/Core/routes/app_routes.dart';
import 'package:habit_tracker/Features/day_planner/day_planner_screen.dart';
import 'package:habit_tracker/Features/finance/finance_wallet_screen.dart';
import 'package:habit_tracker/Features/goal_tracker/goals_tracker_screen.dart';
import 'package:habit_tracker/Features/others/widgets/notice_slide_show.dart';
import 'package:habit_tracker/Features/routine/routine_screen.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
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
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create new',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const Text(
                'Add a new task, habit, goal, journal note or vision item.',
                style: TextStyle(color: Color(0xFF6E7DA7), height: 1.5),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildQuickAction('Task', Icons.schedule_rounded),
                  _buildQuickAction('Routine', Icons.checklist_rtl_rounded),
                  _buildQuickAction('Goal', Icons.flag_rounded),
                  _buildQuickAction('Journal', Icons.edit_rounded),
                  _buildQuickAction('Vision', Icons.image_rounded),
                ],
              ),
              const SizedBox(height: 18),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickAction(String label, IconData icon) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF7C77F2), size: 24),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // mainAxisSize: MainAxisSize.min,
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

class DashboardOverviewScreen extends StatelessWidget {
  const DashboardOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.financeWallet);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C77F2).withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // ← keeps the pill tight
                      children: [
                        CircleAvatar(
                          radius: 13,
                          backgroundColor:
                              const Color(0xFF7C77F2).withValues(alpha: 0.16),
                          child: const Icon(
                              Icons.account_balance_wallet_rounded,
                              size: 18,
                              color: Color(0xFF7C77F2)),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "20000000",
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7C77F2),
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Text(
              'Your productivity hub',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800, height: 1.1),
            ),
            const SizedBox(height: 18),
            Row(children: [
              Expanded(
                  child: _buildSummaryCard(
                "Tasks",
                "target",
                "4/5",
                "",
              )),
              const SizedBox(width: 14),
              Expanded(
                  child: _buildSummaryCard("Streak", "fire", "2 days", "")),
              const SizedBox(width: 14),
              Expanded(
                  child: _buildSummaryCard("Mood", "smiling-face", "Good", "")),
            ]),
            _buildTitleWidget('Today\'s schedule', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DayPlannerScreen()),
              );
            }),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: (0.04)),
                    blurRadius: 18,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 18.0),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Text(
                        '9:00 AM',
                        style: TextStyle(
                            fontSize: 14.3, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Morning routine',
                        style: TextStyle(
                            fontSize: 14.6, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _buildTitleWidget('Routines', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RoutineScreen()),
              );
            }),
            const SizedBox(height: 22),
            // Row(
            //   children: [
            //     Expanded(
            //         child: _buildSummaryCard(
            //             'Today plan', '5 items', 'Soft focus')),
            //     const SizedBox(width: 14),
            //     Expanded(
            //         child: _buildSummaryCard(
            //             'Routines', '3 habits', '84% complete',
            //             soft: true)),
            //   ],
            // ),
            const SizedBox(height: 20),
            // const Text(
            //   'Quick actions',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            // ),
            // const SizedBox(height: 12),
            // GridView.builder(
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 3, // number of items in each row
            //     mainAxisSpacing: 8.0, // spacing between rows
            //     crossAxisSpacing: 8.0, // spacing between columns
            //   ),
            //   itemCount: 5,
            //   shrinkWrap: true,
            //   itemBuilder: (context, index) {
            //     return _buildQuickCard(context, 'Vision',
            //         Icons.photo_library_rounded, const VisionBoardScreen());
            //   },
            // ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     _buildQuickCard(context, 'Routine', Icons.checklist_rtl_rounded,
            //         const RoutineScreen()),
            //     _buildQuickCard(context, 'Journal', Icons.edit_note_rounded,
            //         const JournalScreen()),
            //     _buildQuickCard(context, 'Vision', Icons.photo_library_rounded,
            //         const VisionBoardScreen()),
            //     _buildQuickCard(context, 'Vision', Icons.photo_library_rounded,
            //         const VisionBoardScreen()),
            //     _buildQuickCard(context, 'Vision', Icons.photo_library_rounded,
            //         const VisionBoardScreen()),
            //   ],
            // ),
            const SizedBox(height: 22),
            const _SectionHeader(title: 'Today\'s focus'),
            const SizedBox(height: 12),
            NoticeSlideshow(),
            // _buildTaskPreview(
            //   '3:00 PM',
            //   'Design review',
            //   'Set a calm pace for your afternoon sprint.',
            // ),
            // const SizedBox(height: 12),
            // _buildTaskPreview(
            //   '4:30 PM',
            //   'Goals refresh',
            //   'Update milestones and note progress.',
            // ),
            const SizedBox(height: 22),
            const _SectionHeader(title: 'Progress overview'),
            const SizedBox(height: 12),
            _buildProgressTile(
              'Routines on track',
              '12 of 14 habits completed this week.',
              0.86,
            ),
            const SizedBox(height: 12),
            _buildProgressTile(
              'Finance snapshot',
              'Balance view, income and expense trends.',
              0.64,
            ),
          ],
        ),
      ),
    );
  }

  Row _buildTitleWidget(String title, Function()? onViewAll) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
      const SizedBox(width: 14),
      TextButton(
        onPressed: onViewAll,
        child: const Text('View All'),
      ),
    ]);
  }

  Widget _buildBadge(String label, [bool active = false]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF7C77F2) : const Color(0xFFF2F5FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : const Color(0xFF5F6E8A),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String iconName, String amount, String caption,
      {bool soft = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: soft ? const Color(0xFFF5F7FF) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: (0.04)),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(color: Color(0xFF7B8CB5)),
              ),
              const SizedBox(width: 6),
              Image.asset(
                'assets/images/$iconName.png',
                width: 16,
                height: 16,
              ),
            ],
          ),
          // const SizedBox(height: 10),
          Text(
            amount,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          // const SizedBox(height: 10),
          // Text(
          //   caption,
          //   style: const TextStyle(color: Color(0xFF5F6E8A)),
          // ),
        ],
      ),
    );
  }

  Widget _buildQuickCard(
      BuildContext context, String title, IconData icon, Widget screen) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
      ),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 142,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: (0.04)),
              blurRadius: 18,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   width: 44,
            //   height: 44,
            //   decoration: BoxDecoration(
            //     color: const Color(0xFF7C77F2).withValues(alpha: (0.16)),
            //     borderRadius: BorderRadius.circular(14),
            //   ),
            //   child: Icon(icon, color: const Color(0xFF7C77F2)),
            // ),
            // const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            // const SizedBox(height: 8),
            // const Text(
            //   'Open the module for quick actions.',
            //   style: TextStyle(
            //       color: Color(0xFF7B8CB5), fontSize: 12, height: 1.5),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskPreview(String time, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: (0.04)),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              time,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: Color(0xFF5C6BC0)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(color: Color(0xFF7B8CB5), height: 1.5),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFF7B8CB5)),
        ],
      ),
    );
  }

  Widget _buildProgressTile(String title, String subtitle, double value) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: (0.04)),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              Text(
                '${(value * 100).round()}%',
                style: const TextStyle(
                    color: Color(0xFF7C77F2), fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xFF7B8CB5), height: 1.5),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              color: const Color(0xFF7C77F2),
              backgroundColor: const Color(0xFFE9EEFF),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        Text(
          'View all',
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
