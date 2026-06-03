import 'package:flutter/material.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  final List<Map<String, dynamic>> _routines = [
    {
      'title': 'Morning wellness',
      'subtitle': 'Hydration, stretch, meditation',
      'progress': 0.9,
      'completed': false,
    },
    {
      'title': 'Work focus',
      'subtitle': 'Priority blocks + review',
      'progress': 0.76,
      'completed': true,
    },
    {
      'title': 'Evening reset',
      'subtitle': 'Reflect, plan, unwind',
      'progress': 0.58,
      'completed': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routine Builder'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Build calming habits',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create healthy routines and repeatable templates for every day.',
                style: TextStyle(color: Color(0xFF5F6E8A), height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                      child: _buildMetricCard(
                          'Completed', '18/21', const Color(0xFF7C77F2))),
                  const SizedBox(width: 14),
                  Expanded(
                      child: _buildMetricCard(
                          'Streak', '5 days', const Color(0xFF64B5F6))),
                ],
              ),
              const SizedBox(height: 22),
              Expanded(
                child: ListView.separated(
                  itemCount: _routines.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = _routines[index];
                    return Container(
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
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item['subtitle'],
                                        style: const TextStyle(
                                            color: Color(0xFF7B8CB5),
                                            height: 1.4),
                                      ),
                                    ],
                                  ),
                                ),
                                Checkbox(
                                  value: item['completed'],
                                  activeColor: const Color(0xFF7C77F2),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  onChanged: (value) {
                                    setState(() {
                                      item['completed'] = value ?? false;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: LinearProgressIndicator(
                                value: item['progress'],
                                minHeight: 10,
                                color: const Color(0xFF7C77F2),
                                backgroundColor: const Color(0xFFE9EEFF),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${(item['progress'] * 100).round()}% complete',
                                  style:
                                      const TextStyle(color: Color(0xFF5F6E8A)),
                                ),
                                Text(
                                  item['completed'] ? 'Done' : 'In progress',
                                  style: const TextStyle(
                                      color: Color(0xFF7C77F2),
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildRoutineChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String subtitle, Color accent) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Color(0xFF7B8CB5)),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w800, color: accent),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineChart() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly rhythm',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((day) => _buildDayBar(day, day == 'Wed' ? 0.9 : 0.6))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDayBar(String day, double fill) {
    return Column(
      children: [
        Container(
          width: 10,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFE9EEFF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 10,
              height: 80 * fill,
              decoration: BoxDecoration(
                color: const Color(0xFF7C77F2),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: const TextStyle(fontSize: 12, color: Color(0xFF7B8CB5)),
        ),
      ],
    );
  }
}
