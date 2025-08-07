import 'package:fitcalc/core/theme.dart';
import 'package:fitcalc/features/bmi_calculator/views/bmi_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    // ProviderScope è il widget che memorizza lo stato di tutti i provider.
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitCalc',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Si adatta al tema del sistema
      debugShowCheckedModeBanner: false,
      home: const BmiView(),
    );
  }
}
