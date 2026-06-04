import 'dart:math';
import 'package:flutter/material.dart';

enum TimerMode { pomodoro, zen }

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);
  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  TimerMode _mode = TimerMode.pomodoro;
  bool _running = false;
  int _elapsed = 0; // seconds elapsed
  int _sessionsCompleted = 2;

  static const int _pomoDuration = 25 * 60;
  static const int _zenMax = 90 * 60;

  late AnimationController _modeAnimController;
  late Animation<double> _modeAnim;

  // Ticker for 1-second interval
  late AnimationController _tickController;

  static const Color _pomoColor = Color(0xFFE74C3C);
  static const Color _zenColor = Color(0xFF1D9E75);
  static const Color _pomoTrack = Color(0xFF3D1A1A);
  static const Color _zenTrack = Color(0xFF0A2E24);
  static const Color _surface = Color(0xFF1A1A2E);

  Color get _activeColor =>
      _mode == TimerMode.pomodoro ? _pomoColor : _zenColor;
  Color get _trackColor => _mode == TimerMode.pomodoro ? _pomoTrack : _zenTrack;

  double get _progress {
    if (_mode == TimerMode.pomodoro) {
      return 1 - (_elapsed / _pomoDuration);
    } else {
      return (_elapsed / _zenMax).clamp(0.0, 1.0);
    }
  }

  String get _timeDisplay {
    if (_mode == TimerMode.pomodoro) {
      final remaining = (_pomoDuration - _elapsed).clamp(0, _pomoDuration);
      return _formatTime(remaining);
    } else {
      return _formatTime(_elapsed);
    }
  }

  String _formatTime(int secs) {
    final m = secs ~/ 60;
    final s = secs % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _modeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _modeAnim =
        CurvedAnimation(parent: _modeAnimController, curve: Curves.easeInOut);

    _tickController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && _running) {
          setState(() {
            _elapsed++;
            if (_mode == TimerMode.pomodoro && _elapsed >= _pomoDuration) {
              _elapsed = _pomoDuration;
              _running = false;
            }
          });
          if (_running) _tickController.forward(from: 0);
        }
      });
  }

  @override
  void dispose() {
    _modeAnimController.dispose();
    _tickController.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() => _running = !_running);
    if (_running) {
      _tickController.forward(from: 0);
    } else {
      _tickController.stop();
    }
  }

  void _reset() {
    _tickController.stop();
    setState(() {
      _running = false;
      _elapsed = 0;
    });
  }

  void _skip() {
    _tickController.stop();
    setState(() {
      _running = false;
      _elapsed = _mode == TimerMode.pomodoro ? _pomoDuration : 0;
    });
  }

  void _switchMode(TimerMode m) {
    if (_mode == m) return;
    _tickController.stop();
    setState(() {
      _running = false;
      _elapsed = 0;
      _mode = m;
    });
    _modeAnimController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildModeToggle(),
            const SizedBox(height: 16),
            _buildSessionChips(),
            const SizedBox(height: 8),
            _buildTimerRing(),
            const SizedBox(height: 12),
            _buildDetailsRow(),
            const SizedBox(height: 20),
            _buildControls(),
            const Spacer(),
            _buildQuote(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildModeToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          _modeChip(TimerMode.pomodoro, '🍅 Pomodoro', _pomoColor),
          _modeChip(TimerMode.zen, '🍃 Zen', _zenColor),
        ],
      ),
    );
  }

  Widget _modeChip(TimerMode m, String label, Color activeColor) {
    final active = _mode == m;
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchMode(m),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(46),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: active ? Colors.white : Colors.white38,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionChips() {
    final total = 4;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final done = i < _sessionsCompleted;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? _activeColor : Colors.white12,
          ),
        );
      }),
    );
  }

  Widget _buildTimerRing() {
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(240, 240),
            painter: ArcPainter(
              progress: _progress,
              activeColor: _activeColor,
              trackColor: _trackColor,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _timeDisplay,
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w400,
                  color: _activeColor,
                  letterSpacing: -2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _mode == TimerMode.pomodoro ? 'FOCUS' : 'FLOWING',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 3,
                  color: _activeColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsRow() {
    final items = _mode == TimerMode.pomodoro
        ? [
            ('$_sessionsCompleted', 'sessions'),
            ('25m', 'duration'),
            ('5m', 'break'),
          ]
        : [
            (_formatTime(_elapsed), 'elapsed'),
            ('90m', 'max'),
            ('∞', 'no limit'),
          ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: items
            .map((e) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(e.$1,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                        const SizedBox(height: 3),
                        Text(e.$2,
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white38,
                                letterSpacing: .5)),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _iconBtn(Icons.refresh_rounded, _reset),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: _togglePlay,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: _activeColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _running ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        const SizedBox(width: 20),
        _iconBtn(Icons.skip_next_rounded, _skip),
      ],
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(color: _surface, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white54, size: 22),
      ),
    );
  }

  Widget _buildQuote() {
    final quotes = _mode == TimerMode.pomodoro
        ? 'Stay focused. One thing at a time.'
        : 'No rush. Let time flow through you.';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        quotes,
        textAlign: TextAlign.center,
        style:
            const TextStyle(fontSize: 13, color: Colors.white24, height: 1.5),
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color trackColor;

  const ArcPainter({
    required this.progress,
    required this.activeColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = cx - 14;
    const strokeW = 10.0;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW;
    canvas.drawCircle(Offset(cx, cy), radius, trackPaint);

    final arcPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;

    final startAngle = -pi / 2;
    final sweepAngle = progress * 2 * pi;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );

    // Dot at arc tip
    final dotAngle = startAngle + sweepAngle;
    final dx = cx + radius * cos(dotAngle);
    final dy = cy + radius * sin(dotAngle);
    final dotPaint = Paint()..color = activeColor;
    canvas.drawCircle(Offset(dx, dy), 6, dotPaint);
  }

  @override
  bool shouldRepaint(covariant ArcPainter old) =>
      old.progress != progress ||
      old.activeColor != activeColor ||
      old.trackColor != trackColor;
}
