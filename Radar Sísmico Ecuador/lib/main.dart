import 'package:flutter/material.dart';

import 'screens/radar_navegacion_screen.dart';

void main() {
  runApp(const RadarSismicoApp());
}

class RadarSismicoApp extends StatelessWidget {
  const RadarSismicoApp({super.key});

  @override
  Widget build(BuildContext context) {
    const colorPrincipal = Color(0xFF176B78);
    const colorTexto = Color(0xFF173B4A);
    const colorFondo = Color(0xFFF3F7FA);
    const colorBorde = Color(0xFFE1EAF0);
    final esquema = ColorScheme.fromSeed(seedColor: colorPrincipal);

    return MaterialApp(
      title: 'Radar Sísmico Ecuador',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: esquema,
        scaffoldBackgroundColor: colorFondo,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: colorFondo,
          foregroundColor: colorTexto,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            color: colorTexto,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: colorBorde),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: colorBorde),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: colorBorde),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: colorPrincipal, width: 1.5),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: esquema.secondaryContainer,
          elevation: 0,
        ),
      ),
      home: const RadarNavegacionScreen(),
    );
  }
}
