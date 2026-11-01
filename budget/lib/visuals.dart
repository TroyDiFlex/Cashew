import 'package:flutter/material.dart';

/// Presentation-only tokens. No persisted preferences or financial models.
abstract final class CharcoalPalette {
  static const background = Color(0xFF080808);
  static const panel = Color(0xFF121212);
  static const raised = Color(0xFF1C1C1C);
  static const border = Color(0xFF2B2B2B);
  static const accent = Color(0xFFFB7185);
  static const text = Color(0xFFF5F5F5);
  static const muted = Color(0xFFA3A3A3);
  static const radius = 14.0;
  static const controlRadius = 10.0;

  static ColorScheme darkScheme({Color primary = accent}) {
    final onAccent =
        primary.computeLuminance() > 0.179 ? background : Colors.white;
    return ColorScheme.dark(
      primary: primary,
      onPrimary: onAccent,
      primaryContainer: raised,
      onPrimaryContainer: primary,
      secondary: primary,
      onSecondary: onAccent,
      secondaryContainer: raised,
      onSecondaryContainer: text,
      tertiary: primary,
      onTertiary: onAccent,
      tertiaryContainer: raised,
      onTertiaryContainer: text,
      background: background,
      onBackground: text,
      surface: panel,
      onSurface: text,
      surfaceVariant: raised,
      onSurfaceVariant: muted,
      outline: muted,
      outlineVariant: border,
      error: const Color(0xFFFF8A80),
      onError: background,
      errorContainer: const Color(0xFF3C191B),
      onErrorContainer: const Color(0xFFFFDAD6),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: text,
      onInverseSurface: background,
      inversePrimary: primary,
      surfaceTint: Colors.transparent,
    );
  }

  static BoxDecoration panelDecoration(BuildContext context,
      {bool glow = false}) {
    final scheme = Theme.of(context).colorScheme;
    final dark = scheme.brightness == Brightness.dark;
    return BoxDecoration(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: dark ? border : scheme.outlineVariant),
      boxShadow: glow && dark
          ? [
              BoxShadow(
                color: scheme.primary.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ]
          : null,
    );
  }

  static ThemeData apply(ThemeData base) {
    final scheme = base.colorScheme;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: const BorderSide(color: border),
    );
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(controlRadius),
      borderSide: const BorderSide(color: border),
    );
    return base.copyWith(
      scaffoldBackgroundColor: background,
      canvasColor: panel,
      cardColor: panel,
      dividerColor: border,
      applyElevationOverlayColor: false,
      cardTheme: CardTheme(color: panel, elevation: 0, shape: shape),
      dialogTheme:
          DialogTheme(backgroundColor: panel, elevation: 0, shape: shape),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: panel,
        modalBackgroundColor: panel,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: raised,
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
