import 'package:fitcalc/features/bmi_calculator/services/bmi_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BmiService V1 Tests', () {
    test('Classic BMI should be calculated correctly', () {
      final result = BmiService.calculateClassicBmi(70, 175);
      expect(result.value, closeTo(22.8, 0.1));
      expect(result.classification, 'Normopeso');
    });

    test('Oxford (New) BMI should be calculated correctly', () {
      final result = BmiService.calculateOxfordBmi(70, 175);
      expect(result.value, closeTo(22.5, 0.1));
      expect(result.classification, 'Normopeso');
    });

    test('Ponderal Index should be calculated correctly', () {
      final result = BmiService.calculatePonderalIndex(70, 175);
      expect(result.value, closeTo(13.0, 0.1));
      expect(result.classification, 'Normopeso');
    });

    test('Should handle invalid height', () {
      final result = BmiService.calculateClassicBmi(70, 0);
      expect(result.value, 0);
      expect(result.classification, 'Altezza non valida');
    });
  });
}
