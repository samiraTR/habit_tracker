import 'package:flutter/material.dart';

class DayPlannerScreen extends StatelessWidget {
  const DayPlannerScreen({Key? key}) : super(key: key);

  static const List<Map<String, String>> _agenda = [
    {
      'time': '8:30 AM',
      'title': 'Morning review',
      'subtitle': 'Mindful planning + stretch'
    },
    {
      'time': '10:00 AM',
      'title': 'Design sprint',
      'subtitle': 'Work blocks and notes'
    },
    {
      'time': '12:30 PM',
      'title': 'Lunch reset',
      'subtitle': 'Healthy meal & walk'
    },
    {
      'time': '3:00 PM',
      'title': 'Client check-in',
      'subtitle': 'Prepare outcome summary'
    },
    {
      'time': '4:30 PM',
      'title': 'Review goals',
      'subtitle': 'Progress and habits'
    },
    {
      'time': '6:00 PM',
      'title': 'Evening unwind',
      'subtitle': 'Journal + plan tomorrow'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day Planner'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today’s Timeline',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Organize tasks with clear time blocks and calm focus.',
                style: TextStyle(fontSize: 16, height: 1.4),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusChip(context, 'Daily', true),
                  _buildStatusChip(context, 'Monthly'),
                  _buildStatusChip(context, 'Yearly'),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  itemCount: _agenda.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = _agenda[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              item['time']!,
                              style: const TextStyle(
                                color: Color(0xFF6E7DA7),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: 4,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFF7C77F2)
                                    .withValues(alpha: (0.3)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: (0.04)),
                                  blurRadius: 18,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['subtitle']!,
                                  style: const TextStyle(
                                    color: Color(0xFF7B8CB5),
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEEF2FF),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Text(
                                        'Focus Session',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF5C6BC0),
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.more_horiz,
                                      color: Color(0xFF9AA5CA),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String label,
      [bool active = false]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF7C77F2) : const Color(0xFFF3F5FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : const Color(0xFF58627D),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
