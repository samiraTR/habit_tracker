import 'package:flutter/material.dart';

class VisionBoardScreen extends StatefulWidget {
  const VisionBoardScreen({Key? key}) : super(key: key);

  @override
  _VisionBoardScreenState createState() => _VisionBoardScreenState();
}

class _VisionBoardScreenState extends State<VisionBoardScreen> {
  final List<Map<String, dynamic>> _cards = [
    {
      'title': 'Minimal workspace',
      'subtitle': 'Organize with clean visuals and calm notes.',
      'color': Color(0xFFEEF2FF),
      'checklist': ['Morning routine', 'Weekly goals'],
    },
    {
      'title': 'Fitness goal',
      'subtitle': 'Reach 15k steps and strength targets.',
      'color': Color(0xFFE8F7F0),
      'checklist': ['Yoga', 'Walk', 'Hydrate'],
    },
    {
      'title': 'Creative idea',
      'subtitle': 'Design a soft product experience.',
      'color': Color(0xFFFFF5E8),
      'checklist': ['Mood board', 'Texture study'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vision Board'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your future space',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Collect ideas, images, cards and goals into a visual board.',
                style: TextStyle(color: Color(0xFF5F6E8A), height: 1.5),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 2.2,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _cards.length,
                  itemBuilder: (context, index) {
                    final card = _cards[index];
                    return Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: card['color'],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card['title'],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            card['subtitle'],
                            style: const TextStyle(
                                color: Color(0xFF5F6E8A), height: 1.5),
                          ),
                          const SizedBox(height: 14),
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: List<Widget>.from(
                                (card['checklist'] as List<String>).map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        const Icon(
                                            Icons
                                                .check_box_outline_blank_rounded,
                                            size: 18,
                                            color: Color(0xFF7C77F2)),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                                color: Color(0xFF4A4F9C)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.attach_file_rounded,
                                  color: Color(0xFF7C77F2)),
                            ),
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
}
