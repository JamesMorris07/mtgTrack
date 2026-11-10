import 'package:flutter/material.dart';

class MtgTrackTheme {
  static ThemeData get qTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 27, 175, 249), // base color
          primary: const Color.fromARGB(255, 80, 187, 240), // primary accent color
          surface: const Color.fromARGB(255, 213, 208, 195), // background color
          outline: const Color.fromARGB(255, 0, 0, 0), // outlines
          onSurface: const Color.fromARGB(255, 0, 0, 0),
          brightness: Brightness.light, // dark mode
          ) ,
  );
}