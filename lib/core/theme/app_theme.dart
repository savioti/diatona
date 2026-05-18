import 'package:flutter/material.dart';

enum AppThemeVariant { ocean, amber, midnight, earth, fire }

extension AppThemeVariantExt on AppThemeVariant {
  String get displayName => switch (this) {
        AppThemeVariant.ocean => 'Ocean',
        AppThemeVariant.amber => 'Amber',
        AppThemeVariant.midnight => 'Midnight',
        AppThemeVariant.earth => 'Earth',
        AppThemeVariant.fire => 'Fire',
      };

  // [background, surface, primary, secondary, tertiary]
  List<Color> get palette => switch (this) {
        AppThemeVariant.ocean => const [
            Color(0xFF02394A),
            Color(0xFF043565),
            Color(0xFF5158BB),
            Color(0xFFF26DF9),
            Color(0xFFEB4B98),
          ],
        AppThemeVariant.amber => const [
            Color(0xFFF08700),
            Color(0xFFF49F0A),
            Color(0xFF00A6A6),
            Color(0xFFEFCA08),
            Color(0xFFBBDEF0),
          ],
        AppThemeVariant.midnight => const [
            Color(0xFF000000),
            Color(0xFF14213D),
            Color(0xFFFCA311),
            Color(0xFFE5E5E5),
            Color(0xFFFFFFFF),
          ],
        AppThemeVariant.earth => const [
            Color(0xFFF0EAD2),
            Color(0xFFDDE5B6),
            Color(0xFF6C584C),
            Color(0xFFA98467),
            Color(0xFFADC178),
          ],
        AppThemeVariant.fire => const [
            Color(0xFFF2F3AE),
            Color(0xFFEDD382),
            Color(0xFF020122),
            Color(0xFFF4442E),
            Color(0xFFFC9E4F),
          ],
      };

  Brightness get brightness => switch (this) {
        AppThemeVariant.ocean => Brightness.dark,
        AppThemeVariant.amber => Brightness.light,
        AppThemeVariant.midnight => Brightness.dark,
        AppThemeVariant.earth => Brightness.light,
        AppThemeVariant.fire => Brightness.light,
      };
}

abstract final class AppTheme {
  static ThemeData build(AppThemeVariant variant) {
    final p = variant.palette;
    final isDark = variant.brightness == Brightness.dark;
    final onBg = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final onSurface = _on(p[1]);
    final onPrimary = _on(p[2]);
    final onSecondary = _on(p[3]);

    return ThemeData(
      useMaterial3: true,
      brightness: variant.brightness,
      scaffoldBackgroundColor: p[0],
      colorScheme: ColorScheme(
        brightness: variant.brightness,
        primary: p[2],
        onPrimary: onPrimary,
        primaryContainer: p[1],
        onPrimaryContainer: onSurface,
        secondary: p[3],
        onSecondary: onSecondary,
        tertiary: p[4],
        onTertiary: _on(p[4]),
        surface: p[1],
        onSurface: onSurface,
        error: const Color(0xFFB00020),
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p[1],
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p[2],
          foregroundColor: onPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p[1],
        selectedColor: p[2],
        labelStyle: TextStyle(color: onSurface),
        secondaryLabelStyle: TextStyle(color: onPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      cardTheme: CardThemeData(
        color: p[1],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return p[2];
          return null;
        }),
        checkColor: WidgetStateProperty.all(onPrimary),
      ),
      iconTheme: IconThemeData(color: onBg),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: onBg, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: onBg, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: onBg),
        bodyMedium: TextStyle(color: onBg.withAlpha(191)),
      ),
    );
  }

  // Returns black or white for maximum contrast against [bg].
  static Color _on(Color bg) =>
      bg.computeLuminance() > 0.35 ? const Color(0xFF1A1A1A) : Colors.white;

  static ThemeData get dark => build(AppThemeVariant.ocean);
}
