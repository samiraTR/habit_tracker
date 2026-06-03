import 'package:flutter/material.dart';

class FinanceWalletScreen extends StatelessWidget {
  FinanceWalletScreen({Key? key}) : super(key: key);

  final List<Map<String, Object>> _expenses = [
    {'label': 'Food', 'amount': '-45', 'color': const Color(0xFF88B4FF)},
    {'label': 'Transport', 'amount': '-18', 'color': const Color(0xFFA48CFF)},
    {'label': 'Wellness', 'amount': '-30', 'color': const Color(0xFF77D4C0)},
    {'label': 'Income', 'amount': '+180', 'color': const Color(0xFFF6B87E)},
  ];

  final List<Map<String, String>> _transactions = [
    {'title': 'Coffee & notes', 'subtitle': 'Today • 10:45 AM', 'amount': '-8'},
    {'title': 'Salary top-up', 'subtitle': 'Today • 8:20 AM', 'amount': '+180'},
    {'title': 'Yoga class', 'subtitle': 'Yesterday • 6:00 PM', 'amount': '-16'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Wallet'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily wallet summary',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Track income, spending, and category trends with calm clarity.',
                style: TextStyle(
                    fontSize: 16, height: 1.5, color: Color(0xFF5F6E8A)),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Balance',
                          style: TextStyle(color: Color(0xFF7B8CB5)),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '\$1,280',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '+12% this month',
                          style: TextStyle(color: Color(0xFF5F6E8A)),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF7C77F2).withOpacity(0.14),
                            ),
                          ),
                          const Text(
                            '68%',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4A4F9C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Category breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              Column(
                children: _expenses.map((item) {
                  final label = item['label'] as String;
                  final color = item['color'] as Color;
                  final amount = item['amount'] as String;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            label == 'Income'
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            color: color,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                label,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F4FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: FractionallySizedBox(
                                  widthFactor: label == 'Income' ? 0.65 : 0.4,
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '\$$amount',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: label == 'Income'
                                ? const Color(0xFF4B8A45)
                                : const Color(0xFF7A62D6),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              const Text(
                'Recent activity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              Column(
                children: _transactions.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title']!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item['subtitle']!,
                              style: const TextStyle(color: Color(0xFF7B8CB5)),
                            ),
                          ],
                        ),
                        Text(
                          item['amount']!,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: item['amount']!.startsWith('+')
                                ? const Color(0xFF3F7D45)
                                : const Color(0xFF7A62D6),
                          ),
                        ),
                      ],
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
}
