// lib/core/styles/global_styles.dart
import 'package:flutter/material.dart';

class KiertColors {
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF131A22);
  static const Color surfaceAlt = Color(0xFF1B232C);
  static const Color border = Color(0xFF26313C);
  static const Color text = Color(0xFFE6EDF3);
  static const Color textMuted = Color(0xFF8B98A5);
  static const Color accent = Color(0xFF2DD4BF);
  static const Color accentDark = Color(0xFF17B6A4);
  static const Color accentAlt = Color(0xFFF0B429);
  static const Color danger = Color(0xFFF85149);
  static const Color success = Color(0xFF3FB950);
}

class KiertTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: KiertColors.background,
      cardColor: KiertColors.surface,
      dividerColor: KiertColors.border,
      primaryColor: KiertColors.accent,
      colorScheme: const ColorScheme.dark(
        primary: KiertColors.accent,
        secondary: KiertColors.accent,
        surface: KiertColors.surface,
        background: KiertColors.background,
        error: KiertColors.danger,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: KiertColors.text),
        bodyMedium: TextStyle(color: KiertColors.text),
        titleLarge: TextStyle(color: KiertColors.text),
        titleMedium: TextStyle(color: KiertColors.text),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: KiertColors.surfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: KiertColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: KiertColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: KiertColors.accent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: KiertColors.danger),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: KiertColors.accent,
          foregroundColor: KiertColors.background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: KiertColors.accent),
      ),
    );
  }

  // ===== TEMAS DE COLOR (para PersonalizacionProvider) =====
  static Map<String, ThemeData> get colorThemes => {
    'default': darkTheme,
    'dark': darkTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      cardColor: const Color(0xFF222244),
      dividerColor: const Color(0xFF333366),
    ),
    'light': ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.white,
      cardColor: const Color(0xFFFFFFFF),
      dividerColor: const Color(0xFFD0D0D0),
      primaryColor: KiertColors.accent,
      colorScheme: const ColorScheme.light(
        primary: KiertColors.accent,
        secondary: KiertColors.accent,
        surface: Colors.white,
        background: Colors.white,
        error: KiertColors.danger,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF1A1A2E)),
        bodyMedium: TextStyle(color: Color(0xFF1A1A2E)),
        titleLarge: TextStyle(color: Color(0xFF1A1A2E)),
        titleMedium: TextStyle(color: Color(0xFF1A1A2E)),
      ),
    ),
    'sunset': darkTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF2D1B1B),
      cardColor: const Color(0xFF3D2B2B),
      dividerColor: const Color(0xFF5A3D3D),
    ),
    'ocean': darkTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF0D1A2D),
      cardColor: const Color(0xFF1A2A3D),
      dividerColor: const Color(0xFF2A4A5A),
    ),
    'aurora': darkTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF1A0D2D),
      cardColor: const Color(0xFF2A1A3A),
      dividerColor: const Color(0xFF3A1A5A),
    ),
    'galaxy': darkTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF0D0D1A),
      cardColor: const Color(0xFF1A1A3A),
      dividerColor: const Color(0xFF2A2A4A),
    ),
    'lava': darkTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF1A0A0A),
      cardColor: const Color(0xFF3A1A1A),
      dividerColor: const Color(0xFF5A2A2A),
    ),
    'forest': darkTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF0A1A0A),
      cardColor: const Color(0xFF1A3A2A),
      dividerColor: const Color(0xFF2A4A3A),
    ),
    'candy': darkTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF1A0A1A),
      cardColor: const Color(0xFF3A1A3A),
      dividerColor: const Color(0xFF4A1A4A),
    ),
    'cyber': darkTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF0A0A1A),
      cardColor: const Color(0xFF1A2A4A),
      dividerColor: const Color(0xFF0A1A3A),
    ),
    'blood': darkTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF1A0000),
      cardColor: const Color(0xFF3A0000),
      dividerColor: const Color(0xFF5A0A0A),
    ),
    'royal': darkTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF0A0A1A),
      cardColor: const Color(0xFF1A0A3A),
      dividerColor: const Color(0xFF2A1A4A),
    ),
    'gold': darkTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF1A1A00),
      cardColor: const Color(0xFF3A3A00),
      dividerColor: const Color(0xFF2A2A0A),
    ),
    'pastel': darkTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF1A0A1A),
      cardColor: const Color(0xFF2A1A2A),
      dividerColor: const Color(0xFF3A1A3A),
    ),
    'neon': darkTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF0A0A1A),
      cardColor: const Color(0xFF1A2A4A),
      dividerColor: const Color(0xFF0A1A3A),
    ),
  };

  // ===== FONDOS DE PERFIL =====
  static Map<String, Gradient> get profileBackgrounds => {
    'default': const LinearGradient(
      colors: [Color(0xFF0D1117), Color(0xFF161B22)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'dark': const LinearGradient(
      colors: [Color(0xFF1A1A2E), Color(0xFF0D1117)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'light': const LinearGradient(
      colors: [Colors.white, Color(0xFFF0F0F0)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'sunset': const LinearGradient(
      colors: [Color(0xFFFF6B6B), Color(0xFFFECA57), Color(0xFFFD79A8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'ocean': const LinearGradient(
      colors: [Color(0xFF00B894), Color(0xFF00CEC9), Color(0xFF0984E3)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'aurora': const LinearGradient(
      colors: [Color(0xFF6C5CE7), Color(0xFF00B894), Color(0xFFFDCB6E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'galaxy': const LinearGradient(
      colors: [Color(0xFF2D3436), Color(0xFF6C5CE7), Color(0xFFFD79A8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'lava': const LinearGradient(
      colors: [Color(0xFFFF6B6B), Color(0xFFE17055), Color(0xFFD63031)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'forest': const LinearGradient(
      colors: [Color(0xFF00B894), Color(0xFF55EFC4), Color(0xFF00CEC9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'candy': const LinearGradient(
      colors: [Color(0xFFFD79A8), Color(0xFFFDCB6E), Color(0xFFA29BFE)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'cyber': const LinearGradient(
      colors: [Color(0xFF00D4FF), Color(0xFF6C5CE7), Color(0xFFFD79A8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'blood': const LinearGradient(
      colors: [Color(0xFFFF0044), Color(0xFFD63031), Color(0xFFFF6B6B)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'royal': const LinearGradient(
      colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE), Color(0xFFFD79A8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'gold': const LinearGradient(
      colors: [Color(0xFFF9CA24), Color(0xFFFDCB6E), Color(0xFFFECA57)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'pastel': const LinearGradient(
      colors: [Color(0xFFFD79A8), Color(0xFFA29BFE), Color(0xFF55EFC4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  };

  // ===== ESTILOS DE MARCO =====
  static Map<String, BoxDecoration> get frameStyles => {
    'none': const BoxDecoration(),
    'classic': BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: KiertColors.accent, width: 4),
    ),
    'gold': BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Color(0xFFF9CA24), width: 4),
      boxShadow: [
        BoxShadow(color: Color(0xFFF9CA24).withOpacity(0.3), blurRadius: 20),
      ],
    ),
    'silver': BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Color(0xFFB2BEC3), width: 4),
      boxShadow: [
        BoxShadow(color: Color(0xFFB2BEC3).withOpacity(0.3), blurRadius: 20),
      ],
    ),
    'rainbow': BoxDecoration(
      shape: BoxShape.circle,
      gradient: const LinearGradient(
        colors: [
          Color(0xFFFF6B6B),
          Color(0xFFFECA57),
          Color(0xFF55EFC4),
          Color(0xFF0984E3),
          Color(0xFF6C5CE7),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(color: Color(0xFFFF6B6B).withOpacity(0.3), blurRadius: 30),
      ],
    ),
    'neon': BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Color(0xFFFD79A8), width: 4),
      boxShadow: [
        BoxShadow(color: Color(0xFFFD79A8).withOpacity(0.5), blurRadius: 25),
      ],
    ),
    'cyber': BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Color(0xFF00D4FF), width: 4),
      boxShadow: [
        BoxShadow(color: Color(0xFF00D4FF).withOpacity(0.6), blurRadius: 40),
      ],
    ),
    'elite': BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Color(0xFF6C5CE7), width: 6),
      boxShadow: [
        BoxShadow(color: Color(0xFF6C5CE7).withOpacity(0.6), blurRadius: 40),
      ],
    ),
  };
}
