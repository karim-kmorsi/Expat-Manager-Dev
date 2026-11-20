import 'package:material_ui/material_ui.dart';

ThemeData expatTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final colors =
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF007D6F),
        brightness: brightness,
      ).copyWith(
        surface: dark ? const Color(0xFF131B1D) : const Color(0xFFF3F7F6),
        surfaceContainerLowest: dark ? const Color(0xFF202B2D) : Colors.white,
      );
  final type = ThemeData(brightness: brightness, colorScheme: colors).textTheme;
  final border = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  );
  final field = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: colors.outlineVariant),
  );
  final buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  );

  return ThemeData(
    colorScheme: colors,
    scaffoldBackgroundColor: colors.surface,
    textTheme: type
        .copyWith(
          titleLarge: type.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          titleMedium: type.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          bodyLarge: type.bodyLarge?.copyWith(height: 1.45),
          bodyMedium: type.bodyMedium?.copyWith(height: 1.40),
          labelLarge: type.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        )
        .apply(fontFamilyFallback: const ['Noto Sans Arabic', 'sans-serif']),
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
      titleSpacing: 18,
      centerTitle: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colors.surfaceContainerLowest,
      indicatorColor: colors.secondaryContainer,
      elevation: 0,
      height: 72,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => type.labelSmall?.copyWith(
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: colors.surfaceContainerLowest,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: border.copyWith(side: BorderSide(color: colors.outlineVariant)),
      clipBehavior: Clip.antiAlias,
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
    dividerTheme: DividerThemeData(
      color: colors.outlineVariant,
      space: 24,
      thickness: 1,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colors.surfaceContainerLowest,
      shape: border,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.surfaceContainerLowest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: field,
      enabledBorder: field,
      focusedBorder: field.copyWith(
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: buttonShape,
        minimumSize: const Size(0, 44),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: buttonShape,
        minimumSize: const Size(0, 44),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: buttonShape,
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}

class AmountLabel extends StatelessWidget {
  const AmountLabel(this.value, {super.key});

  final String value;

  @override
  Widget build(BuildContext context) => Text(
    value,
    textDirection: TextDirection.ltr,
    style: Theme.of(context).textTheme.titleSmall
        ?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
  );
}
