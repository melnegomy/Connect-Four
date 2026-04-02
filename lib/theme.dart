import 'package:flutter/material.dart';

const Color cDark   = Color(0xFF0F0F1E);
const Color cDark2  = Color(0xFF1A1A2E);
const Color cDark3  = Color(0xFF16213E);
const Color cCard   = Color(0xFF1E2240);
const Color cBlue   = Color(0xFF1A56DB);
const Color cBlueLt = Color(0xFF3B82F6);
const Color cYellow = Color(0xFFF59E0B);
const Color cRed    = Color(0xFFEF4444);
const Color cGreen  = Color(0xFF10B981);
const Color cText   = Color(0xFFE2E8F0);
const Color cMuted  = Color(0xFF94A3B8);

ThemeData appTheme() {
  return ThemeData.dark().copyWith(
    scaffoldBackgroundColor: cDark,
    colorScheme: const ColorScheme.dark(primary: cBlue),
  );
}