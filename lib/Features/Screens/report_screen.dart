import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/Features/Widgets/custom_charts.dart';
import 'package:habit_tracker/Features/Screens/profile_screen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Premium Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5F6E8A),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Your Productivity Hub',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  // Glowing avatar placeholder
                  GestureDetector(
                    onTap: () {
                      Get.to(ProfileScreen());
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C77F2), Color(0xFF5C6BC0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C77F2)
                                .withValues(alpha: (0.3)),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'SR',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Top Mini-Stats Cards
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMiniStatCard(
                      'Focus Score',
                      '85%',
                      Icons.insights_rounded,
                      const Color(0xFF7C77F2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMiniStatCard(
                      'Streak',
                      '5 Days',
                      Icons.local_fire_department_rounded,
                      const Color(0xFFFF8A65),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMiniStatCard(
                      'Active',
                      '8 Habits',
                      Icons.task_alt_rounded,
                      const Color(0xFF00BFA5),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Segmented TabBar Container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: TabBar(
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: (0.04)),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: primaryColor,
                unselectedLabelColor: const Color(0xFF7B8CB5),
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                tabs: const [
                  Tab(text: "Yearly"),
                  Tab(text: "Monthly"),
                  Tab(text: "Weekly"),
                  Tab(text: "Daily"),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Tab Views for the Charts
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [
                  YearlyGraphChart(),
                  MonthlyBarChart(),
                  WeeklyBarChart(),
                  DailyPieChart(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: (0.02)),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: (0.12)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF7B8CB5),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
