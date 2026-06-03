import 'package:flutter/material.dart';

class GoalsTrackerScreen extends StatelessWidget {
  const GoalsTrackerScreen({Key? key}) : super(key: key);

  static const _goals = [
    {
      'title': 'Career growth',
      'subtitle': 'Complete certification + mentorship',
      'progress': '0.75'
    },
    {
      'title': 'Fitness goal',
      'subtitle': 'Run 15km weekly + strength routine',
      'progress': '0.58'
    },
    {
      'title': 'Learning path',
      'subtitle': 'Finish 3 courses this month',
      'progress': '0.42'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals Tracker'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Progress with purpose',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Track milestones, celebrate wins, and keep your goals clear.',
                style: TextStyle(
                    fontSize: 16, height: 1.5, color: Color(0xFF5F6E8A)),
              ),
              const SizedBox(height: 24),
              _buildOverviewCard(context),
              const SizedBox(height: 18),
              Column(
                children: _goals.map((goal) {
                  final progress = double.parse(goal['progress']!);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  goal['title']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${(progress * 100).round()}%',
                                  style: const TextStyle(
                                    color: Color(0xFF7C77F2),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              goal['subtitle']!,
                              style: const TextStyle(
                                  color: Color(0xFF6F7B96), height: 1.5),
                            ),
                            const SizedBox(height: 20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 10,
                                color: const Color(0xFF7C77F2),
                                backgroundColor: const Color(0xFFE4E7FF),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 10,
                              runSpacing: 8,
                              children: [
                                _buildMilestoneChip('Milestone 1'),
                                _buildMilestoneChip('In review'),
                                _buildMilestoneChip('Next session'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Monthly momentum',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Text(
                  '3 goals in progress • 12 milestones ahead',
                  style: TextStyle(color: Color(0xFF5F6E8A), height: 1.5),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF7C77F2).withOpacity(0.14),
                    ),
                  ),
                  const Text(
                    '72%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4A4F9C),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMilestoneChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF5D66A6),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
