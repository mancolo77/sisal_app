import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0E1B14); // Deep evergreen
  static const Color surface = Color(0xFF14251C);
  static const Color primary = Color(0xFF00C853); // Vivid green
  static const Color secondary = Color(0xFFAEEA00); // Lime
  static const Color accent = Color(0xFF00E5FF); // Teal
  
  static const Color textPrimary = Color(0xFFF1F5F3);
  static const Color textSecondary = Color(0xFF9FB2A8);
  
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  
  // Additional colors for UI elements
  static const Color cardBackground = Color(0xFF1A2B21);
  static const Color divider = Color(0xFF2A3B32);
  static const Color disabled = Color(0xFF6B7B72);
  
  // Gradient colors
  static const List<Color> primaryGradient = [primary, secondary];
  static const List<Color> backgroundGradient = [background, surface];
  
  // Opacity variations
  static Color primaryWithOpacity(double opacity) => primary.withOpacity(opacity);
  static Color surfaceWithOpacity(double opacity) => surface.withOpacity(opacity);
  static Color textPrimaryWithOpacity(double opacity) => textPrimary.withOpacity(opacity);
}
