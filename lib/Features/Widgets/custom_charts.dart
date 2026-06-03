import 'dart:math' as math;
import 'package:flutter/material.dart';

// ==========================================
// 1. YEARLY GRAPH CHART (Bezier Curve + Tooltip)
// ==========================================

class YearlyGraphChart extends StatefulWidget {
  const YearlyGraphChart({super.key});

  @override
  State<YearlyGraphChart> createState() => _YearlyGraphChartState();
}

class _YearlyGraphChartState extends State<YearlyGraphChart>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 5; // Default to June (index 5)
  late AnimationController _animationController;
  late Animation<double> _revealAnimation;

  final List<Map<String, dynamic>> _yearlyData = [
    {'month': 'Jan', 'value': 0.45},
    {'month': 'Feb', 'value': 0.52},
    {'month': 'Mar', 'value': 0.62},
    {'month': 'Apr', 'value': 0.58},
    {'month': 'May', 'value': 0.70},
    {'month': 'Jun', 'value': 0.78},
    {'month': 'Jul', 'value': 0.85},
    {'month': 'Aug', 'value': 0.74},
    {'month': 'Sep', 'value': 0.88},
    {'month': 'Oct', 'value': 0.82},
    {'month': 'Nov', 'value': 0.91},
    {'month': 'Dec', 'value': 0.87},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _revealAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuart,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTouch(Offset localPosition, double width) {
    // Map X coordinate to the nearest month index
    double sectionWidth = width / 11;
    int index = (localPosition.dx / sectionWidth).round();
    index = index.clamp(0, 11);
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary Card
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Annual Average',
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7B8CB5),
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '72.6%',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: primaryColor),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 40,
                color: const Color(0xFFE2E7F3),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Peak Month',
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7B8CB5),
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'November (91%)',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: secondaryColor),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Main Chart Canvas
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double chartWidth = constraints.maxWidth;
                final double chartHeight =
                    constraints.maxHeight - 30; // Leave room for month labels

                return GestureDetector(
                  onPanDown: (details) =>
                      _handleTouch(details.localPosition, chartWidth),
                  onPanUpdate: (details) =>
                      _handleTouch(details.localPosition, chartWidth),
                  child: Stack(
                    children: [
                      // Grid and Spline
                      AnimatedBuilder(
                        animation: _revealAnimation,
                        builder: (context, child) {
                          return CustomPaint(
                            size: Size(chartWidth, chartHeight),
                            painter: _YearlySplinePainter(
                              data: _yearlyData,
                              selectedIndex: _selectedIndex,
                              revealProgress: _revealAnimation.value,
                              primaryColor: primaryColor,
                              secondaryColor: secondaryColor,
                            ),
                          );
                        },
                      ),
                      // Labels Row
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 24,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(12, (index) {
                            final isSelected = index == _selectedIndex;
                            return Expanded(
                              child: Text(
                                _yearlyData[index]['month'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? primaryColor
                                      : const Color(0xFF7B8CB5),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _YearlySplinePainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final int selectedIndex;
  final double revealProgress;
  final Color primaryColor;
  final Color secondaryColor;

  _YearlySplinePainter({
    required this.data,
    required this.selectedIndex,
    required this.revealProgress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double sectionWidth = width / 11;

    // 1. Draw Horizontal Gridlines (0%, 25%, 50%, 75%, 100%)
    final gridPaint = Paint()
      ..color = const Color(0xFFF2F4FA)
      ..strokeWidth = 1.0;

    final gridLabelPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i <= 4; i++) {
      double y = height * (1 - (i * 0.25));
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);

      // Label
      gridLabelPainter.text = TextSpan(
        text: '${i * 25}%',
        style: const TextStyle(
            fontSize: 8, color: Color(0xFFB0B9D4), fontWeight: FontWeight.w600),
      );
      gridLabelPainter.layout();
      gridLabelPainter.paint(canvas, Offset(2, y - 10));
    }

    // Convert data to points
    List<Offset> points = [];
    for (int i = 0; i < 12; i++) {
      double val = data[i]['value'] as double;
      // Animate from 0 to full height on load
      double animatedVal = val * revealProgress;
      double x = i * sectionWidth;
      double y = height - (animatedVal * height);
      points.add(Offset(x, y));
    }

    if (points.isEmpty) return;

    // 2. Draw Area Under Spline (Gradient Fill)
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final controlX1 = p1.dx + (p2.dx - p1.dx) / 2;
      final controlY1 = p1.dy;
      final controlX2 = p1.dx + (p2.dx - p1.dx) / 2;
      final controlY2 = p2.dy;

      path.cubicTo(controlX1, controlY1, controlX2, controlY2, p2.dx, p2.dy);
    }

    // Close the path to form a polygon under the curve
    final fillPath = Path.from(path);
    fillPath.lineTo(width, height);
    fillPath.lineTo(0, height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primaryColor.withOpacity(0.24),
          primaryColor.withOpacity(0.00),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawPath(fillPath, fillPaint);

    // 3. Draw Spline Line (Stroke)
    final strokePaint = Paint()
      ..shader = LinearGradient(
        colors: [primaryColor, secondaryColor],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, strokePaint);

    // 4. Draw Selected Indicator Line
    final selectedX = selectedIndex * sectionWidth;
    final selectedY = points[selectedIndex].dy;

    final verticalLinePaint = Paint()
      ..color = primaryColor.withOpacity(0.15)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
        Offset(selectedX, 0), Offset(selectedX, height), verticalLinePaint);

    // 5. Draw Dots on Nodes
    final nodeOuterPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final nodeInnerPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      final isSelected = i == selectedIndex;

      if (isSelected) {
        // Glowing dot
        canvas.drawCircle(
            p, 8.0, Paint()..color = primaryColor.withOpacity(0.25));
        canvas.drawCircle(p, 6.0, nodeOuterPaint);
        canvas.drawCircle(p, 4.0, Paint()..color = secondaryColor);
      } else {
        canvas.drawCircle(p, 4.5, nodeOuterPaint);
        canvas.drawCircle(p, 2.5, nodeInnerPaint);
      }
    }

    // 6. Draw Tooltip Box
    final tooltipVal = ((data[selectedIndex]['value'] as double) * 100).round();
    final tooltipText = '${data[selectedIndex]['month']}: $tooltipVal%';

    final tooltipPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: tooltipText,
        style: const TextStyle(
            color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
    tooltipPainter.layout();

    final double tooltipW = tooltipPainter.width + 16;
    final double tooltipH = tooltipPainter.height + 10;

    // Position tooltip above the point, adjusting for edges
    double tooltipX = selectedX - (tooltipW / 2);
    tooltipX = tooltipX.clamp(4.0, width - tooltipW - 4.0);
    double tooltipY = selectedY - tooltipH - 12;
    if (tooltipY < 4) {
      tooltipY = selectedY + 12; // Draw below point if too high
    }

    final tooltipRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tooltipX, tooltipY, tooltipW, tooltipH),
      const Radius.circular(8),
    );

    final tooltipBgPaint = Paint()
      ..color = const Color(0xFF1E293B) // Premium dark tooltip
      ..style = PaintingStyle.fill;

    canvas.drawRRect(tooltipRRect, tooltipBgPaint);
    tooltipPainter.paint(canvas, Offset(tooltipX + 8, tooltipY + 5));
  }

  @override
  bool shouldRepaint(covariant _YearlySplinePainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.revealProgress != revealProgress ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}

// ==========================================
// 2. MONTHLY BAR CHART (Horizontal scrollable bars + Info card)
// ==========================================

class MonthlyBarChart extends StatefulWidget {
  const MonthlyBarChart({super.key});

  @override
  State<MonthlyBarChart> createState() => _MonthlyBarChartState();
}

class _MonthlyBarChartState extends State<MonthlyBarChart> {
  int _selectedDayIndex = 14; // Default to Day 15 (index 14)
  final ScrollController _scrollController = ScrollController();

  // Mock data for 30 days of the month
  final List<double> _monthlyRates = [
    0.75,
    0.80,
    0.65,
    0.40,
    0.85,
    0.90,
    0.70,
    0.60,
    0.50,
    0.80,
    0.75,
    0.95,
    0.88,
    0.64,
    0.78,
    0.84,
    0.90,
    0.82,
    0.68,
    0.72,
    0.88,
    0.92,
    0.85,
    0.60,
    0.76,
    0.80,
    0.84,
    0.90,
    0.95,
    0.88
  ];

  @override
  void initState() {
    super.initState();
    // Scroll to center selected bar after rendering
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        double offset = (_selectedDayIndex * 38.0) -
            (MediaQuery.of(context).size.width / 2) +
            38.0;
        _scrollController.animateTo(
          offset.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    double monthlySum = _monthlyRates.reduce((a, b) => a + b);
    double monthlyAvg = monthlySum / _monthlyRates.length;

    // Details of selected day
    double selectedRate = _monthlyRates[_selectedDayIndex];
    int habitsDone = (selectedRate * 8).round(); // Assume 8 total habits
    int totalHabits = 8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monthly Completion',
                    style: TextStyle(color: Color(0xFF7B8CB5), fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(monthlyAvg * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: primaryColor),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9FBF0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up, color: Color(0xFF2E7D32), size: 18),
                    SizedBox(width: 6),
                    Text(
                      '+5% vs May',
                      style: TextStyle(
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w700,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Scrollable Chart Container
        Container(
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: _monthlyRates.length,
            itemBuilder: (context, index) {
              final rate = _monthlyRates[index];
              final isSelected = index == _selectedDayIndex;
              final dayNum = index + 1;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDayIndex = index;
                  });
                },
                child: Container(
                  width: 26,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      // The progress capsule
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F4FA),
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? Border.all(color: primaryColor, width: 1.5)
                                : null,
                          ),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              FractionallySizedBox(
                                heightFactor: rate,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: isSelected
                                          ? [
                                              primaryColor,
                                              const Color(0xFF5C6BC0)
                                            ]
                                          : [
                                              primaryColor.withOpacity(0.7),
                                              primaryColor.withOpacity(0.4)
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color:
                                                  primaryColor.withOpacity(0.3),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            )
                                          ]
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Day number text
                      Text(
                        '$dayNum',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w500,
                          color: isSelected
                              ? primaryColor
                              : const Color(0xFF7B8CB5),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Selected Day Info Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // Circular progress for details
                SizedBox(
                  width: 54,
                  height: 54,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: selectedRate,
                        strokeWidth: 5,
                        backgroundColor: const Color(0xFFE9EEFF),
                        color: primaryColor,
                        strokeCap: StrokeCap.round,
                      ),
                      Center(
                        child: Text(
                          '${(selectedRate * 100).round()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'June ${_selectedDayIndex + 1} Progress',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$habitsDone of $totalHabits habits completed',
                        style: const TextStyle(
                            color: Color(0xFF7B8CB5), fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.check_circle,
                    color: selectedRate >= 0.8
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFF7C77F2),
                    size: 28),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 3. WEEKLY BAR CHART (7 capsules + Animation + Daily log list)
// ==========================================

class WeeklyBarChart extends StatefulWidget {
  const WeeklyBarChart({super.key});

  @override
  State<WeeklyBarChart> createState() => _WeeklyBarChartState();
}

class _WeeklyBarChartState extends State<WeeklyBarChart>
    with SingleTickerProviderStateMixin {
  int _selectedDay = 2; // Default to Wednesday (index 2)
  late AnimationController _animController;

  final List<Map<String, dynamic>> _weeklyData = [
    {
      'day': 'Mon',
      'rate': 0.75,
      'habits': [
        {'name': 'Stretch & Hydration', 'done': true},
        {'name': 'Work Focus Blocks', 'done': true},
        {'name': 'Read for 20 mins', 'done': true},
        {'name': 'Journal Entry', 'done': false},
      ]
    },
    {
      'day': 'Tue',
      'rate': 0.50,
      'habits': [
        {'name': 'Stretch & Hydration', 'done': true},
        {'name': 'Work Focus Blocks', 'done': false},
        {'name': 'Read for 20 mins', 'done': true},
        {'name': 'Journal Entry', 'done': false},
      ]
    },
    {
      'day': 'Wed',
      'rate': 0.90,
      'habits': [
        {'name': 'Stretch & Hydration', 'done': true},
        {'name': 'Work Focus Blocks', 'done': true},
        {'name': 'Read for 20 mins', 'done': true},
        {'name': 'Journal Entry', 'done': true},
      ]
    },
    {
      'day': 'Thu',
      'rate': 0.60,
      'habits': [
        {'name': 'Stretch & Hydration', 'done': true},
        {'name': 'Work Focus Blocks', 'done': true},
        {'name': 'Read for 20 mins', 'done': false},
        {'name': 'Journal Entry', 'done': false},
      ]
    },
    {
      'day': 'Fri',
      'rate': 0.80,
      'habits': [
        {'name': 'Stretch & Hydration', 'done': true},
        {'name': 'Work Focus Blocks', 'done': true},
        {'name': 'Read for 20 mins', 'done': true},
        {'name': 'Journal Entry', 'done': false},
      ]
    },
    {
      'day': 'Sat',
      'rate': 0.40,
      'habits': [
        {'name': 'Stretch & Hydration', 'done': false},
        {'name': 'Work Focus Blocks', 'done': false},
        {'name': 'Read for 20 mins', 'done': true},
        {'name': 'Journal Entry', 'done': true},
      ]
    },
    {
      'day': 'Sun',
      'rate': 0.95,
      'habits': [
        {'name': 'Stretch & Hydration', 'done': true},
        {'name': 'Work Focus Blocks', 'done': true},
        {'name': 'Read for 20 mins', 'done': true},
        {'name': 'Journal Entry', 'done': true},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    final selectedDayData = _weeklyData[_selectedDay];
    final List<Map<String, dynamic>> selectedHabits =
        List<Map<String, dynamic>>.from(selectedDayData['habits']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Weekly rhythm card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Weekly rhythm',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Week Target: 80%',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: secondaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final data = _weeklyData[index];
                  final isSelected = index == _selectedDay;
                  final rate = data['rate'] as double;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDay = index;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 22,
                          height: 110,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F4FA),
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(color: primaryColor, width: 1.5)
                                : null,
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: ScaleTransition(
                                  scale: _animController,
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: double.infinity,
                                    height: constraints.maxHeight * rate,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [primaryColor, secondaryColor],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data['day'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w800 : FontWeight.w500,
                            color: isSelected
                                ? primaryColor
                                : const Color(0xFF7B8CB5),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),

        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          child: Text(
            '${selectedDayData['day']} Log details',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),

        // Habits checked list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: selectedHabits.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final habit = selectedHabits[index];
              final bool done = habit['done'] as bool;

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: done
                            ? const Color(0xFFEEF9EE)
                            : const Color(0xFFFFF3F2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        done ? Icons.check : Icons.close,
                        color: done
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFC62828),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        habit['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: done
                              ? const Color(0xFF33415C)
                              : const Color(0xFF7B8CB5),
                          decoration: done ? null : TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                    Text(
                      done ? 'Completed' : 'Missed',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: done
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFC62828),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 4. DAILY PIE CHART (Donut + Dynamic segments + Legend interaction)
// ==========================================

class DailyPieChart extends StatefulWidget {
  const DailyPieChart({super.key});

  @override
  State<DailyPieChart> createState() => _DailyPieChartState();
}

class _DailyPieChartState extends State<DailyPieChart>
    with SingleTickerProviderStateMixin {
  int _activeCategoryIndex = 0; // Default: Routines
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  final List<Map<String, dynamic>> _pieData = [
    {
      'category': 'Routines',
      'percentage': 0.40,
      'count': '4/5 done',
      'color': const Color(0xFF7C77F2),
      'icon': Icons.checklist_rtl_rounded,
      'tasks': [
        'Morning stretch',
        'Drink 1L water',
        'Vitamins',
        'Read book',
        'Evening meditation (missed)'
      ],
    },
    {
      'category': 'Planner Tasks',
      'percentage': 0.30,
      'count': '3/4 done',
      'color': const Color(0xFF5C6BC0),
      'icon': Icons.schedule_rounded,
      'tasks': [
        'Design sprint session',
        'Client presentation code',
        'Sync with backend developer',
        'Write release notes (pending)'
      ],
    },
    {
      'category': 'Goals Tracker',
      'percentage': 0.20,
      'count': '1/1 done',
      'color': const Color(0xFF00BFA5),
      'icon': Icons.flag_rounded,
      'tasks': ['Complete SwiftUI module 3'],
    },
    {
      'category': 'Journaling',
      'percentage': 0.10,
      'count': '1/1 done',
      'color': const Color(0xFFFFB74D),
      'icon': Icons.edit_rounded,
      'tasks': ['Write daily reflection'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handlePieTap(Offset localPosition, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double dx = localPosition.dx - centerX;
    final double dy = localPosition.dy - centerY;
    final double distance = math.sqrt(dx * dx + dy * dy);

    // Filter clicks in the donut ring (radius between 45 and 90)
    if (distance >= 35 && distance <= 95) {
      double angle = math.atan2(dy, dx);
      if (angle < 0) {
        angle += 2 * math.pi;
      }

      // Determine which slice was clicked
      double startAngle = -math.pi / 2; // Arcs start from the top
      for (int i = 0; i < _pieData.length; i++) {
        double sweepAngle = _pieData[i]['percentage'] * 2 * math.pi;
        double endAngle = startAngle + sweepAngle;

        // Normalize endAngle for wrapping comparison
        double normalizedAngle = angle;
        double tempStart = startAngle;
        double tempEnd = endAngle;

        // Handle wrapping around 2pi
        if (tempStart < 0) {
          tempStart += 2 * math.pi;
          tempEnd += 2 * math.pi;
          if (normalizedAngle < tempStart &&
              normalizedAngle < tempEnd - 2 * math.pi) {
            normalizedAngle += 2 * math.pi;
          }
        }

        if (normalizedAngle >= tempStart && normalizedAngle <= tempEnd) {
          if (_activeCategoryIndex != i) {
            setState(() {
              _activeCategoryIndex = i;
              _animController.reset();
              _animController.forward();
            });
          }
          break;
        }
        startAngle = endAngle;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = _pieData[_activeCategoryIndex];
    final List<String> taskList = List<String>.from(selectedCategory['tasks']);

    return Column(
      children: [
        // Pie Chart Visual Section
        Container(
          height: 180,
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              // The Pie/Donut Chart Canvas
              Expanded(
                flex: 4,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double w = constraints.maxWidth;
                    final double h = constraints.maxHeight;
                    final size = Size(w, h);

                    return GestureDetector(
                      onTapUp: (details) =>
                          _handlePieTap(details.localPosition, size),
                      child: Stack(
                        children: [
                          AnimatedBuilder(
                            animation: _scaleAnimation,
                            builder: (context, child) {
                              return CustomPaint(
                                size: size,
                                painter: _DonutChartPainter(
                                  data: _pieData,
                                  activeIndex: _activeCategoryIndex,
                                  scaleProgress: _scaleAnimation.value,
                                ),
                              );
                            },
                          ),
                          // Text in center of Donut
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Aggregated',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF7B8CB5),
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  '75%',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF33415C)),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  'Completed',
                                  style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Interactive Legends Column
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_pieData.length, (index) {
                    final item = _pieData[index];
                    final isSelected = index == _activeCategoryIndex;
                    final percentStr = (item['percentage'] * 100).round();

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _activeCategoryIndex = index;
                          _animController.reset();
                          _animController.forward();
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? item['color'].withOpacity(0.08)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(
                                  color: item['color'].withOpacity(0.3),
                                  width: 1)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: item['color'],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item['category'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? const Color(0xFF33415C)
                                      : const Color(0xFF7B8CB5),
                                ),
                              ),
                            ),
                            Text(
                              '$percentStr%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: isSelected
                                    ? item['color']
                                    : const Color(0xFF7B8CB5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
        ),

        // Subtitle Card / Category details
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Icon(selectedCategory['icon'],
                  color: selectedCategory['color'], size: 20),
              const SizedBox(width: 8),
              Text(
                '${selectedCategory['category']} (${selectedCategory['count']})',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: selectedCategory['color'],
                ),
              ),
            ],
          ),
        ),

        // Tasks checklist breakdown for selected category
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            itemCount: taskList.length,
            itemBuilder: (context, index) {
              final taskName = taskList[index];
              final bool isMissed = taskName.contains('(missed)');
              final bool isPending = taskName.contains('(pending)');
              final bool isDone = !isMissed && !isPending;

              Color statusColor = Colors.green.shade600;
              IconData statusIcon = Icons.check_circle_outline;
              if (isMissed) {
                statusColor = Colors.red.shade600;
                statusIcon = Icons.remove_circle_outline;
              } else if (isPending) {
                statusColor = Colors.orange.shade600;
                statusIcon = Icons.hourglass_empty_rounded;
              }

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.015),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        taskName
                            .replaceAll(' (missed)', '')
                            .replaceAll(' (pending)', ''),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDone
                              ? const Color(0xFF33415C)
                              : const Color(0xFF7B8CB5),
                          decoration:
                              isDone ? null : TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                    Text(
                      isDone
                          ? 'Completed'
                          : isMissed
                              ? 'Missed'
                              : 'Pending',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final int activeIndex;
  final double scaleProgress;

  _DonutChartPainter({
    required this.data,
    required this.activeIndex,
    required this.scaleProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Dimensions of donut
    final double baseRadius = math.min(centerX, centerY) - 18;
    const double strokeW = 16.0;

    double startAngle = -math.pi / 2; // Start from top 12 o'clock

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final sweepAngle = item['percentage'] * 2 * math.pi;
      final isSelfActive = i == activeIndex;

      // Calculate radius and thickness adjustments for active slice
      // Active slice explodes out and swells in stroke width slightly
      final double explodeOffset = isSelfActive ? 6.0 * scaleProgress : 0.0;
      final double arcStrokeW =
          isSelfActive ? strokeW + (3.0 * scaleProgress) : strokeW;
      final double arcRadius =
          isSelfActive ? baseRadius + (2.0 * scaleProgress) : baseRadius;

      final paint = Paint()
        ..color = item['color']
        ..style = PaintingStyle.stroke
        ..strokeWidth = arcStrokeW
        ..strokeCap = StrokeCap.round;

      // Explode calculations: move center of active arc outwards along bisector angle
      final double bisectorAngle = startAngle + (sweepAngle / 2);
      final double explodeX = centerX + math.cos(bisectorAngle) * explodeOffset;
      final double explodeY = centerY + math.sin(bisectorAngle) * explodeOffset;
      final adjustedCenter = Offset(explodeX, explodeY);

      final rect = Rect.fromCircle(center: adjustedCenter, radius: arcRadius);

      // Create a slight gap by drawing the arc slightly smaller than its full sweep
      const double gapAngle = 0.08; // gap in radians

      if (sweepAngle > gapAngle * 2) {
        canvas.drawArc(
          rect,
          startAngle + gapAngle,
          sweepAngle - (gapAngle * 2),
          false,
          paint,
        );
      } else {
        canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      }

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.activeIndex != activeIndex ||
        oldDelegate.scaleProgress != scaleProgress;
  }
}
