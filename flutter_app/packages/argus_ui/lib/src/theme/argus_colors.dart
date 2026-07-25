import 'package:flutter/material.dart';

@immutable
class ArgusColors extends ThemeExtension<ArgusColors> {
  const ArgusColors({
    required this.brandAccent,
    required this.brandAccentDark,
    
    // Statuses
    required this.statusOpen,
    required this.statusAssigned,
    required this.statusInProgress,
    required this.statusResolved,
    required this.statusClosed,
    required this.statusSlaBreached,
    
    // Severities
    required this.severityCritical,
    required this.severityMajor,
    required this.severityMinor,

    // Slate scale / panels
    required this.panelBackground,
    required this.panelBorder,
    required this.textPrimary,
    required this.textSecondary,
  });

  // Factory constructor for Light Mode
  factory ArgusColors.light() {
    return const ArgusColors(
      brandAccent: Color(0xFFF59E0B),      // Amber 500
      brandAccentDark: Color(0xFFD97706),  // Amber 600
      
      statusOpen: Color(0xFF3B82F6),        // Blue 500
      statusAssigned: Color(0xFF8B5CF6),    // Purple 500
      statusInProgress: Color(0xFFF59E0B),  // Amber 500
      statusResolved: Color(0xFF10B981),    // Emerald 500
      statusClosed: Color(0xFF64748B),      // Slate 500
      statusSlaBreached: Color(0xFFEF4444), // Red 500
      
      severityCritical: Color(0xFFEF4444),  // Red 500
      severityMajor: Color(0xFFF97316),     // Orange 500
      severityMinor: Color(0xFFEAB308),     // Yellow 500
      
      panelBackground: Color(0xFFFFFFFF),   // White
      panelBorder: Color(0xFFE2E8F0),       // Slate 200
      textPrimary: Color(0xFF0F172A),       // Slate 900
      textSecondary: Color(0xFF64748B),     // Slate 500
    );
  }

  // Factory constructor for Dark Mode
  factory ArgusColors.dark() {
    return const ArgusColors(
      brandAccent: Color(0xFFF59E0B),      // Amber 500
      brandAccentDark: Color(0xFFD97706),  // Amber 600
      
      statusOpen: Color(0xFF3B82F6),        // Blue 500
      statusAssigned: Color(0xFF8B5CF6),    // Purple 500
      statusInProgress: Color(0xFFF59E0B),  // Amber 500
      statusResolved: Color(0xFF10B981),    // Emerald 500
      statusClosed: Color(0xFF64748B),      // Slate 500
      statusSlaBreached: Color(0xFFEF4444), // Red 500
      
      severityCritical: Color(0xFFEF4444),  // Red 500
      severityMajor: Color(0xFFF97316),     // Orange 500
      severityMinor: Color(0xFFEAB308),     // Yellow 500
      
      panelBackground: Color(0xFF1E293B),   // Slate 800
      panelBorder: Color(0xFF334155),       // Slate 700
      textPrimary: Color(0xFFF8FAFC),       // Slate 50
      textSecondary: Color(0xFF64748B),     // Slate 500
    );
  }

  final Color brandAccent;
  final Color brandAccentDark;

  final Color statusOpen;
  final Color statusAssigned;
  final Color statusInProgress;
  final Color statusResolved;
  final Color statusClosed;
  final Color statusSlaBreached;

  final Color severityCritical;
  final Color severityMajor;
  final Color severityMinor;

  final Color panelBackground;
  final Color panelBorder;
  final Color textPrimary;
  final Color textSecondary;

  @override
  ArgusColors copyWith({
    Color? brandAccent,
    Color? brandAccentDark,
    Color? statusOpen,
    Color? statusAssigned,
    Color? statusInProgress,
    Color? statusResolved,
    Color? statusClosed,
    Color? statusSlaBreached,
    Color? severityCritical,
    Color? severityMajor,
    Color? severityMinor,
    Color? panelBackground,
    Color? panelBorder,
    Color? textPrimary,
    Color? textSecondary,
  }) {
    return ArgusColors(
      brandAccent: brandAccent ?? this.brandAccent,
      brandAccentDark: brandAccentDark ?? this.brandAccentDark,
      statusOpen: statusOpen ?? this.statusOpen,
      statusAssigned: statusAssigned ?? this.statusAssigned,
      statusInProgress: statusInProgress ?? this.statusInProgress,
      statusResolved: statusResolved ?? this.statusResolved,
      statusClosed: statusClosed ?? this.statusClosed,
      statusSlaBreached: statusSlaBreached ?? this.statusSlaBreached,
      severityCritical: severityCritical ?? this.severityCritical,
      severityMajor: severityMajor ?? this.severityMajor,
      severityMinor: severityMinor ?? this.severityMinor,
      panelBackground: panelBackground ?? this.panelBackground,
      panelBorder: panelBorder ?? this.panelBorder,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
    );
  }

  @override
  ArgusColors lerp(ThemeExtension<ArgusColors>? other, double t) {
    if (other is! ArgusColors) {
      return this;
    }
    return ArgusColors(
      brandAccent: Color.lerp(brandAccent, other.brandAccent, t)!,
      brandAccentDark: Color.lerp(brandAccentDark, other.brandAccentDark, t)!,
      statusOpen: Color.lerp(statusOpen, other.statusOpen, t)!,
      statusAssigned: Color.lerp(statusAssigned, other.statusAssigned, t)!,
      statusInProgress: Color.lerp(statusInProgress, other.statusInProgress, t)!,
      statusResolved: Color.lerp(statusResolved, other.statusResolved, t)!,
      statusClosed: Color.lerp(statusClosed, other.statusClosed, t)!,
      statusSlaBreached: Color.lerp(statusSlaBreached, other.statusSlaBreached, t)!,
      severityCritical: Color.lerp(severityCritical, other.severityCritical, t)!,
      severityMajor: Color.lerp(severityMajor, other.severityMajor, t)!,
      severityMinor: Color.lerp(severityMinor, other.severityMinor, t)!,
      panelBackground: Color.lerp(panelBackground, other.panelBackground, t)!,
      panelBorder: Color.lerp(panelBorder, other.panelBorder, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }
}
