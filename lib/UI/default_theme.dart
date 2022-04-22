import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class DefaultTheme {
  static var lightTheme = FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: Color(0xff303f9f),
      primaryVariant: Color(0xff1a237e),
      secondary: Color(0xff512da8),
      secondaryVariant: Color(0xff311b92),
      appBarColor: Color(0xff311b92),
      error: Color(0xffb00020),
    ),
    surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
    blendLevel: 40,
    appBarStyle: FlexAppBarStyle.primary,
    appBarOpacity: 0.95,
    appBarElevation: 2,
    transparentStatusBar: true,
    tabBarStyle: FlexTabBarStyle.forAppBar,
    tooltipsMatchBackground: true,
    swapColors: false,
    lightIsWhite: false,
    useSubThemes: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    // To use playground font, add GoogleFonts package and uncomment:
    // fontFamily: GoogleFonts.notoSans().fontFamily,
    subThemesData: const FlexSubThemesData(
      useTextTheme: true,
      fabUseShape: true,
      interactionEffects: true,
      bottomNavigationBarElevation: 0,
      bottomNavigationBarOpacity: 0.95,
      navigationBarOpacity: 0.95,
      navigationBarMutedUnselectedText: true,
      navigationBarMutedUnselectedIcon: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: true,
      blendOnColors: true,
      blendTextTheme: true,
      popupMenuOpacity: 0.95,
    ),
  );
  static var darkTheme = FlexThemeData.dark(
    colors: const FlexSchemeColor(
      primary: Color(0xff222E3C),
      primaryVariant: Color(0xff222E3C),
      secondary: Color(0xff61A9E0),
      secondaryVariant: Color(0xff61A9E0),
      appBarColor: Color(0xff222E3C),
      error: Color(0xffb00020),
    ),
    surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
    blendLevel: 40,
    appBarStyle: FlexAppBarStyle.primary,
    appBarOpacity: 0.95,
    appBarElevation: 9,
    transparentStatusBar: true,
    tabBarStyle: FlexTabBarStyle.forAppBar,
    tooltipsMatchBackground: true,
    swapColors: false,
    darkIsTrueBlack: false,
    useSubThemes: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    // To use playground font, add GoogleFonts package and uncomment:
    // fontFamily: GoogleFonts.notoSans().fontFamily,
    subThemesData: const FlexSubThemesData(
      useTextTheme: true,
      fabUseShape: true,
      interactionEffects: true,
      bottomNavigationBarElevation: 0,
      bottomNavigationBarOpacity: 0.95,
      navigationBarOpacity: 0.95,
      navigationBarMutedUnselectedText: true,
      navigationBarMutedUnselectedIcon: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: true,
      blendOnColors: true,
      blendTextTheme: true,
      popupMenuOpacity: 0.95,
    ),
    background: const Color(0xff151D26),
    scaffoldBackground: const Color(0xff151D26),
    dialogBackground: const Color(0xff2e3033),
  );
}
