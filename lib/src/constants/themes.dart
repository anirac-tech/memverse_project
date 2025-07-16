// ===========================
//        THEME USAGE GUIDE
// ===========================
// All colors, typography, spacing, radii, shadows, etc, are centralized below.
// To update the app's visual identity (light or dark), change values here.
// Use AppThemes.light/dark/feedback for MaterialApp and feedback overlays.
// For custom widget padding/spacings: use pagePadding / cardRadius, etc.
// Typography: ALWAYS use Theme.of(context).textTheme, or the role-specific text style below.
// Colors: reference only the tokens below (e.g., mvLightGreen), never Colors.* in other files.
// Button/Card/Snackbar/Dialog/etc. themes: update the relevant ThemeData section here, not individual widgets.
// This keeps the UI consistent and makes future rebrands super easy!
// ===========================

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

const Color secondaryButtonColorLight = mvLightNavInactive;
const Color secondaryButtonColorDark = mvDarkNavInactive;
const Color secondaryButtonTextColor = Colors.white; // Or mvLightGreen for less contrast

// TYPOGRAPHY/MISC CONSTANTS
const double pagePadding = 20;
const double cardRadius = 16;
const double buttonRadius = 12;
const EdgeInsets verticalPadding = EdgeInsets.symmetric(vertical: 16);
const EdgeInsets horizontalPadding = EdgeInsets.symmetric(horizontal: 20);

// =============== CARD TOKENS ===============
const Color cardColorLight = Colors.white;
const Color cardColorDark = Color(0xFF23321F);
const double cardElevationDefault = 2;

// =============== TYPOGRAPHY TOKEN CONSTANTS ===============
const double fontSizeHeadline = 26;
const double fontSizeBody = 16;
const double fontSizeNavLabel = 13;
const double fontSizeNavLabelUnselected = 12.2;
const double letterSpacingTight = 0.04;
const double letterSpacingWide = 0.05;
const FontWeight fontWeightBold = FontWeight.bold;
const FontWeight fontWeightSemiBold = FontWeight.w600;
const FontWeight fontWeightRegular = FontWeight.w400;

// =============== SIZING TOKEN CONSTANTS ===============
const double navIconSize = 28;
const double appBarTitleFontSize = 20;

// =============== FEEDBACK THEME TOKEN CONSTANTS ===============
const int feedbackOverlayAlpha = 235; // Almost solid, but not quite
const Color feedbackOrange = Color(0xFFE28600);
const Color feedbackRed = Color(0xFFE52020);
const Color feedbackBlue = Color(0xFF1C7CF6);
const Color feedbackDarkSheet = Color(0xFF1D2724);
const Color feedbackLightSheet = Colors.white;

// Feedback draw palette: NOT brand colors, just highly visible choices for annotation,
// tuned for each background (see also https://raw.githubusercontent.com/ueman/feedback/master/img/theme_description.png)
// Try: black (visible on light), white (on dark), red, blue, orange, (optionally) green.
const List<Color> feedbackLightDrawColors = [
  Colors.black, // Maximum contrast on light
  feedbackRed, // Error
  feedbackBlue, // Annotation
  feedbackOrange, // Warning/highlight
  mvLightGreen, // Accept/positive, optional
];
const List<Color> feedbackDarkDrawColors = [
  Colors.white, // Maximum contrast on dark
  feedbackRed, // Error
  feedbackBlue, // Annotation
  feedbackOrange, // Warning/highlight
  mvDarkGreen, // Accept/positive, optional
];

const TextTheme customLightTextTheme = TextTheme(
  headlineMedium: TextStyle(
    fontSize: fontSizeHeadline,
    fontWeight: fontWeightBold,
    color: mvLightGreen,
  ),
  bodyMedium: TextStyle(fontSize: fontSizeBody, color: Colors.black),
  labelMedium: TextStyle(
    fontWeight: fontWeightSemiBold,
    letterSpacing: letterSpacingWide,
    color: mvLightGreen,
  ),
  labelSmall: TextStyle(
    fontWeight: fontWeightRegular,
    letterSpacing: letterSpacingTight,
    color: mvLightNavInactive,
  ),
);

const TextTheme customDarkTextTheme = TextTheme(
  headlineMedium: TextStyle(
    fontSize: fontSizeHeadline,
    fontWeight: fontWeightBold,
    color: mvDarkGreen,
  ),
  bodyMedium: TextStyle(fontSize: fontSizeBody, color: Colors.white),
  labelMedium: TextStyle(
    fontWeight: fontWeightSemiBold,
    letterSpacing: letterSpacingWide,
    color: mvDarkGreen,
  ),
  labelSmall: TextStyle(
    fontWeight: fontWeightRegular,
    letterSpacing: letterSpacingTight,
    color: mvDarkNavInactive,
  ),
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
      titleTextStyle: TextStyle(
        fontSize: appBarTitleFontSize,
        color: mvLightGreen,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
      elevation: cardElevationDefault,
      margin: horizontalPadding,
      color: cardColorLight,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: mvLightNavBg,
      selectedItemColor: mvLightNavText,
      unselectedItemColor: mvLightNavInactive,
      selectedLabelStyle: TextStyle(
        fontWeight: fontWeightSemiBold,
        letterSpacing: letterSpacingWide,
        fontSize: fontSizeNavLabel,
        color: mvLightNavText,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: fontWeightRegular,
        letterSpacing: letterSpacingTight,
        fontSize: fontSizeNavLabelUnselected,
        color: mvLightNavInactive,
      ),
      selectedIconTheme: IconThemeData(size: navIconSize),
      unselectedIconTheme: IconThemeData(size: navIconSize),
      type: BottomNavigationBarType.fixed,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonRadius)),
        padding: verticalPadding,
        textStyle: const TextStyle(fontWeight: fontWeightBold),
        backgroundColor: mvLightGreen,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonRadius)),
        padding: verticalPadding,
        textStyle: TextStyle(fontWeight: fontWeightBold),
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
      titleTextStyle: TextStyle(
        fontSize: appBarTitleFontSize,
        color: mvDarkGreen,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
      elevation: cardElevationDefault,
      margin: horizontalPadding,
      color: cardColorDark,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: mvDarkNavBg,
      selectedItemColor: mvDarkNavText,
      unselectedItemColor: mvDarkNavInactive,
      selectedLabelStyle: TextStyle(
        fontWeight: fontWeightSemiBold,
        letterSpacing: letterSpacingWide,
        fontSize: fontSizeNavLabel,
        color: mvDarkNavText,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: fontWeightRegular,
        letterSpacing: letterSpacingTight,
        fontSize: fontSizeNavLabelUnselected,
        color: mvDarkNavInactive,
      ),
      selectedIconTheme: IconThemeData(size: navIconSize),
      unselectedIconTheme: IconThemeData(size: navIconSize),
      type: BottomNavigationBarType.fixed,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonRadius)),
        padding: verticalPadding,
        textStyle: TextStyle(fontWeight: fontWeightBold),
        backgroundColor: mvDarkGreen,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonRadius)),
        padding: verticalPadding,
        textStyle: TextStyle(fontWeight: fontWeightBold),
        side: const BorderSide(color: mvDarkGreen),
      ),
    ),
  );

  static final feedbackTheme = FeedbackThemeData(
    background: mvLightNavBg.withAlpha(feedbackOverlayAlpha),
    feedbackSheetColor: feedbackLightSheet,
    drawColors: feedbackLightDrawColors,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      primary: mvLightGreen,
      onPrimary: Colors.white,
      secondary: secondaryButtonColorLight,
      onSecondary: Colors.white,
      error: feedbackRed,
      onError: Colors.white,
      surface: feedbackLightSheet,
      onSurface: mvLightGreen,
      background: mvLightNavBg,
      onBackground: mvLightGreen,
      seedColor: mvLightGreen,
    ),
    // activeFeedbackModeColor: Used for the 'Submit' button AND for the highlighted 'Draw' button (mode selector) in the feedback overlay/tool
    // See feedback readme: https://raw.githubusercontent.com/ueman/feedback/master/img/theme_description.png
    activeFeedbackModeColor: mvLightGreen,
  );
  static final feedbackDarkTheme = FeedbackThemeData(
    background: mvDarkNavBg.withAlpha(feedbackOverlayAlpha),
    feedbackSheetColor: feedbackDarkSheet,
    drawColors: feedbackDarkDrawColors,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      primary: mvDarkGreen,
      onPrimary: Colors.white,
      secondary: secondaryButtonColorDark,
      onSecondary: Colors.white,
      error: feedbackRed,
      onError: Colors.white,
      surface: feedbackDarkSheet,
      onSurface: mvDarkGreen,
      background: mvDarkNavBg,
      onBackground: mvDarkGreen,
      seedColor: mvDarkGreen,
    ),
    // activeFeedbackModeColor: Used for the 'Submit' button AND for the highlighted 'Draw' button (mode selector) in the feedback overlay/tool
    // See feedback readme: https://raw.githubusercontent.com/ueman/feedback/master/img/theme_description.png
    activeFeedbackModeColor: mvDarkGreen,
  );
}
