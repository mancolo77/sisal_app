import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/colors/app_colors.dart';
import '../../core/typography/app_typography.dart';
import '../../core/utils/quiz_utils.dart';

class QuizTimer extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;
  final bool isPaused;

  const QuizTimer({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
    this.isPaused = false,
  });

  @override
  Widget build(BuildContext context) {
    final progress = remainingSeconds / totalSeconds;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getTimerColor(progress).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getTimerColor(progress),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Timer icon with progress ring
          SizedBox(
            width: 20,
            height: 20,
            child: Stack(
              children: [
                // Progress ring
                CustomPaint(
                  size: const Size(20, 20),
                  painter: _TimerRingPainter(
                    progress: progress,
                    color: _getTimerColor(progress),
                  ),
                ),
                // Timer icon
                Center(
                  child: Icon(
                    isPaused ? Icons.pause : Icons.timer,
                    size: 12,
                    color: _getTimerColor(progress),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          
          // Time text
          Text(
            QuizUtils.formatTime(remainingSeconds),
            style: AppTypography.monoSmall.copyWith(
              color: _getTimerColor(progress),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTimerColor(double progress) {
    if (isPaused) {
      return AppColors.textSecondary;
    } else if (progress > 0.5) {
      return AppColors.primary;
    } else if (progress > 0.2) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }
}

class _TimerRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _TimerRingPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;
    
    // Background ring
    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Progress ring
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    const startAngle = -math.pi / 2; // Start from top
    final sweepAngle = 2 * math.pi * progress;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _TimerRingPainter &&
        (oldDelegate.progress != progress || oldDelegate.color != color);
  }
}
