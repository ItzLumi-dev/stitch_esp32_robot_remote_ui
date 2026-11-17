import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Tactile Mecha-OS Light Typography & Shadows
class AppStyles {
  AppStyles._();

  // Headlines: Space Grotesk
  static TextStyle headlineXl({Color color = AppColors.onSurface}) =>
      GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.5,
        color: color,
      );

  static TextStyle headlineLg({Color color = AppColors.onSurface}) =>
      GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.3,
        color: color,
      );

  static TextStyle headlineMd({Color color = AppColors.onSurface}) =>
      GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: color,
      );

  // Body: Plus Jakarta Sans
  static TextStyle bodyLg({Color color = AppColors.onSurface}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: color,
      );

  static TextStyle bodyMd({Color color = AppColors.onSurface}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: color,
      );

  static TextStyle bodySm({Color color = AppColors.onSurfaceVariant}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 1.3,
        color: color,
      );

  // Labels & Telemetry: JetBrains Mono
  static TextStyle labelLg({Color color = AppColors.onSurface, FontWeight weight = FontWeight.w600}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 13,
        fontWeight: weight,
        letterSpacing: 0.5,
        color: color,
      );

  static TextStyle labelMd({Color color = AppColors.onSurface, FontWeight weight = FontWeight.w600}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 11,
        fontWeight: weight,
        letterSpacing: 0.4,
        color: color,
      );

  static TextStyle labelSm({Color color = AppColors.onSurfaceVariant, FontWeight weight = FontWeight.w600}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 9.5,
        fontWeight: weight,
        letterSpacing: 0.3,
        color: color,
      );

  // Tactile Pod Card Shadow
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF0F172A).withOpacity(0.04),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: const Color(0xFF0F172A).withOpacity(0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  // Micro Beveled Tactile Button Shadow
  static List<BoxShadow> tactileButtonShadow({Color lipColor = AppColors.tactileLip}) => [
    BoxShadow(
      color: lipColor,
      blurRadius: 0,
      offset: const Offset(0, 3),
    ),
    BoxShadow(
      color: const Color(0xFF0F172A).withOpacity(0.06),
      blurRadius: 6,
      offset: const Offset(0, 3),
    ),
  ];
}
