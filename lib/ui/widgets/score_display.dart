import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/colors/app_colors.dart';
import '../../core/typography/app_typography.dart';

class ScoreDisplay extends StatefulWidget {
  final double score;
  final String grade;

  const ScoreDisplay({
    super.key,
    required this.score,
    required this.grade,
  });

  @override
  State<ScoreDisplay> createState() => _ScoreDisplayState();
}

class _ScoreDisplayState extends State<ScoreDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(
      begin: 0.0,
      end: widget.score / 100,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: _getScoreColor().withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Score circle
                SizedBox(
                  width: 160,
                  height: 160,
                  child: Stack(
                    children: [
                      // Progress ring
                      CustomPaint(
                        size: const Size(160, 160),
                        painter: _ScoreRingPainter(
                          progress: _scoreAnimation.value,
                          color: _getScoreColor(),
                        ),
                      ),
                      // Score text
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${(_scoreAnimation.value * 100).round()}%',
                              style: AppTypography.monoLarge.copyWith(
                                fontSize: 36,
                                color: _getScoreColor(),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'SCORE',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textSecondary,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Grade display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _getScoreColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getScoreColor().withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.grade,
                    style: AppTypography.h4.copyWith(
                      color: _getScoreColor(),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getScoreColor() {
    if (widget.score >= 90) return AppColors.success;
    if (widget.score >= 80) return AppColors.primary;
    if (widget.score >= 70) return AppColors.secondary;
    if (widget.score >= 60) return AppColors.warning;
    return AppColors.error;
  }
}

class _ScoreRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ScoreRingPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    
    // Background ring
    final backgroundPaint = Paint()
      ..color = AppColors.divider
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Progress ring
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
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
    
    // Add sparkle effect for high scores
    if (progress > 0.9) {
      _drawSparkles(canvas, center, radius);
    }
  }

  void _drawSparkles(Canvas canvas, Offset center, double radius) {
    final sparkPaint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    // Draw small sparkles around the ring
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) + (progress * 2 * math.pi);
      final sparkleCenter = Offset(
        center.dx + (radius + 15) * math.cos(angle),
        center.dy + (radius + 15) * math.sin(angle),
      );
      
      canvas.drawCircle(sparkleCenter, 2, sparkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _ScoreRingPainter &&
        (oldDelegate.progress != progress || oldDelegate.color != color);
  }
}
