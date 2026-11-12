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

    return MaterialApp(
      title: 'Radar Sísmico Ecuador',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: colorPrincipal),
        scaffoldBackgroundColor: const Color(0xFFF4F7F9),
        appBarTheme: const AppBarTheme(centerTitle: false),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const RadarNavegacionScreen(),
    );
  }
}
