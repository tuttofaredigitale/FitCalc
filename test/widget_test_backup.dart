import 'package:fitcalc/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App starts and shows initial UI', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verifichiamo che il nuovo titolo sia presente.
    expect(find.text('FitCalc'), findsOneWidget);

    // E verifichiamo anche gli altri campi.
    expect(find.widgetWithText(TextFormField, 'Altezza (cm)'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Peso (kg)'), findsOneWidget);
  });
}
