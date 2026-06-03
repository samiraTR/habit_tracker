import 'package:flutter/material.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  String _activeMood = 'Calm';

  final List<Map<String, String>> _entries = [
    {
      'title': 'Morning clarity',
      'snippet': 'Noticed the calm from a steady morning routine...',
      'mood': 'Focus',
      'date': 'Today',
    },
    {
      'title': 'Deep learning',
      'snippet': 'Reviewed my goals and built a better study habit...',
      'mood': 'Inspired',
      'date': 'Yesterday',
    },
    {
      'title': 'Evening reset',
      'snippet': 'Wind down with gratitude and gentle notes.',
      'mood': 'Calm',
      'date': '2 days ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Write your mind',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Capture mood, ideas, and reflections in a calm space.',
                style: TextStyle(color: Color(0xFF5F6E8A), height: 1.5),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search entries',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: const Color(0xFFF5F7FF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildMoodChip('Calm'),
                    _buildMoodChip('Focused'),
                    _buildMoodChip('Inspired'),
                    _buildMoodChip('Grateful'),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  itemCount: _entries.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final entry = _entries[index];
                    return Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
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
                                entry['title']!,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                entry['date']!,
                                style:
                                    const TextStyle(color: Color(0xFF7B8CB5)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            entry['snippet']!,
                            style: const TextStyle(
                                color: Color(0xFF5F6E8A), height: 1.5),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F7FF),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  entry['mood']!,
                                  style: const TextStyle(
                                      color: Color(0xFF7C77F2),
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.chevron_right_rounded,
                                  color: Color(0xFF7B8CB5)),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildMoodChip(String mood) {
    final bool isActive = _activeMood == mood;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(mood),
        selected: isActive,
        selectedColor: const Color(0xFF7C77F2),
        backgroundColor: const Color(0xFFF5F7FF),
        labelStyle: TextStyle(
          color: isActive ? Colors.white : const Color(0xFF5F6E8A),
          fontWeight: FontWeight.w700,
        ),
        onSelected: (_) {
          setState(() {
            _activeMood = mood;
          });
        },
      ),
    );
  }
}
