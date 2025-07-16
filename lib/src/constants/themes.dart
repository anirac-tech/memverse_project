import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';

// COLOR CONSTANTS (use for theme)
const Color mvLightScaffoldBg = Color(0xFFF8FFF0);
const Color mvLightNavBg = Color(0xFFF4FFF0);
const Color mvLightGreen = Color(0xFF224600);
const Color mvLightNavText = Color(0xFF224600);
const Color mvLightNavInactive = Color(0xFF5D6E60);
const Color mvDarkScaffoldBg = Color(0xFF111D14);
const Color mvDarkNavBg = Color(0xFF19391E);
const Color mvDarkGreen = Color(0xFF91FF7B);
const Color mvDarkNavText = Color(0xFFDAFFD3);
const Color mvDarkNavInactive = Color(0xFF338855);

// TYPOGRAPHY/MISC CONSTANTS
const double kPagePadding = 20.0;
const double kCardRadius = 16.0;
const double kButtonRadius = 12.0;
const double kCardElevation = 2.0;
const EdgeInsets kVerticalPadding = EdgeInsets.symmetric(vertical: 16);
const EdgeInsets kHorizontalPadding = EdgeInsets.symmetric(horizontal: 20);

final customLightTextTheme = TextTheme(
  headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: mvLightGreen),
  bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
  labelMedium: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.05, color: mvLightGreen),
  labelSmall: TextStyle(
    fontWeight: FontWeight.w400,
    letterSpacing: 0.04,
    color: mvLightNavInactive,
  ),
);

final customDarkTextTheme = TextTheme(
  headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: mvDarkGreen),
  bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
  labelMedium: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.05, color: mvDarkGreen),
  labelSmall: TextStyle(fontWeight: FontWeight.w400, letterSpacing: 0.04, color: mvDarkNavInactive),
);

class AppThemes {
  static final light = ThemeData(
    scaffoldBackgroundColor: mvLightScaffoldBg,
    colorScheme: ColorScheme.fromSeed(seedColor: mvLightGreen),
    textTheme: customLightTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: mvLightNavBg,
      elevation: 0,
      iconTheme: IconThemeData(color: mvLightGreen),
      titleTextStyle: TextStyle(fontSize: 20, color: mvLightGreen, fontWeight: FontWeight.bold),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
      elevation: kCardElevation,
      margin: kHorizontalPadding,
      color: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: mvLightNavBg,
      selectedItemColor: mvLightNavText,
      unselectedItemColor: mvLightNavInactive,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.05,
        color: mvLightNavText,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w400,
        letterSpacing: 0.04,
        color: mvLightNavInactive,
      ),
      selectedIconTheme: IconThemeData(size: 28),
      unselectedIconTheme: IconThemeData(size: 28),
      type: BottomNavigationBarType.fixed,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kButtonRadius)),
        padding: kVerticalPadding,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: mvLightGreen,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kButtonRadius)),
        padding: kVerticalPadding,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        side: const BorderSide(color: mvLightGreen),
      ),
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: mvDarkScaffoldBg,
    colorScheme: ColorScheme.fromSeed(seedColor: mvDarkGreen, brightness: Brightness.dark),
    textTheme: customDarkTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: mvDarkNavBg,
      elevation: 0,
      iconTheme: IconThemeData(color: mvDarkGreen),
      titleTextStyle: TextStyle(fontSize: 20, color: mvDarkGreen, fontWeight: FontWeight.bold),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
      elevation: kCardElevation,
      margin: kHorizontalPadding,
      color: Color(0xFF23321F),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: mvDarkNavBg,
      selectedItemColor: mvDarkNavText,
      unselectedItemColor: mvDarkNavInactive,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.05,
        color: mvDarkNavText,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w400,
        letterSpacing: 0.04,
        color: mvDarkNavInactive,
      ),
      selectedIconTheme: IconThemeData(size: 28),
      unselectedIconTheme: IconThemeData(size: 28),
      type: BottomNavigationBarType.fixed,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kButtonRadius)),
        padding: kVerticalPadding,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: mvDarkGreen,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kButtonRadius)),
        padding: kVerticalPadding,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        side: const BorderSide(color: mvDarkGreen),
      ),
    ),
  );

  static final feedbackTheme = FeedbackThemeData(
    background: mvLightNavBg.withAlpha(235),
    feedbackSheetColor: Colors.white,
    drawColors: [mvLightGreen, Color(0xFFE28600), Color(0xFFE52020), Color(0xFF1C7CF6)],
  );
  static final feedbackDarkTheme = FeedbackThemeData(
    background: mvDarkNavBg.withAlpha(235),
    feedbackSheetColor: const Color(0xFF1D2724),
    drawColors: [mvDarkGreen, Color(0xFFE28600), Color(0xFFE52020), Color(0xFF82B1FF)],
  );
}
