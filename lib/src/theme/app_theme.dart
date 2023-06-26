import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const primaryColor = Color(0xff8A1D5C);
const secondaryAccent = Color(0xffE10086);

const pageTransitionsTheme = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  },
);



class AppTheme {
  ThemeData appTheme = ThemeData(
    useMaterial3: true,
    pageTransitionsTheme: pageTransitionsTheme,
    // Add this line
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xffF8FAFD),
      brightness: Brightness.light,
    ),
    fontFamily: "Mulish",
    appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: secondaryAccent,
          statusBarIconBrightness: Brightness.light,
          // For Android (dark icons)
          statusBarBrightness: Brightness.dark, // For iOS (dark icons)
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        titleTextStyle: TextStyle(fontFamily: "Mulish", fontSize: 20),
        iconTheme: IconThemeData(color: Colors.white)),
    textTheme: const TextTheme(
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: "Mulish"),
        titleMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontFamily: "Mulish"),
        labelSmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          fontFamily: "Mulish"
        ),
        // labelLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 28),
        labelMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          fontFamily: "Mulish"
        )),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 13)),
            elevation: MaterialStateProperty.all(0.0),
            backgroundColor: MaterialStateProperty.all(primaryColor),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
            minimumSize: MaterialStateProperty.all(const Size.fromHeight(45)))),
    inputDecorationTheme: InputDecorationTheme(
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      hintStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      filled: true,
      fillColor: Colors.grey[50],
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 13)),
            elevation: MaterialStateProperty.all(0.0),
            side: MaterialStateProperty.all(
                const BorderSide(color: Colors.transparent)))),
    tabBarTheme: const TabBarTheme(
        unselectedLabelColor: Colors.white,
        labelColor: Colors.white,
        labelStyle: TextStyle(fontSize: 13, fontFamily: "Mulish"),
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 8.0,
              color: secondaryAccent,
            ),
            insets: EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0))),
    chipTheme: const ChipThemeData(
        showCheckmark: false,
        checkmarkColor: Colors.white,
        selectedColor: primaryColor,
        padding: EdgeInsets.all(15),
        labelStyle: TextStyle(
          fontFamily: "Mulish",
          fontSize: 13,
        ),
        surfaceTintColor: Color(0xffF8FAFD)),
    scaffoldBackgroundColor: const Color(0xffF8FAFD),
  );
}
