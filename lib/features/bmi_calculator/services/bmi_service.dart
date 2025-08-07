import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fitcalc/core/models/bmi_result.dart';

class BmiService {
  // Formula classica del BMI: peso / altezza²
  static BmiResult calculateClassicBmi(double weightKg, double heightCm) {
    if (heightCm <= 0) {
      return BmiResult(
          value: 0, classification: "Altezza non valida", color: Colors.red);
    }
    final heightM = heightCm / 100;
    final bmi = weightKg / (heightM * heightM);
    return _getClassicBmiClassification(bmi);
  }

  // "Nuovo" BMI (Trefethen - Oxford): 1.3 * peso / altezza^2.5
  static BmiResult calculateOxfordBmi(double weightKg, double heightCm) {
    if (heightCm <= 0) {
      return BmiResult(
          value: 0, classification: "Altezza non valida", color: Colors.red);
    }
    final heightM = heightCm / 100;
    final bmi = 1.3 * weightKg / (pow(heightM, 2.5));
    // Usiamo la stessa classificazione del BMI classico per coerenza
    return _getClassicBmiClassification(bmi);
  }

  // Indice Ponderale: peso / altezza³
  static BmiResult calculatePonderalIndex(double weightKg, double heightCm) {
    if (heightCm <= 0) {
      return BmiResult(
          value: 0, classification: "Altezza non valida", color: Colors.red);
    }
    final heightM = heightCm / 100;
    final pi = weightKg / (heightM * heightM * heightM);
    return _getPonderalClassification(pi);
  }

  // Metodi privati per la classificazione
  static BmiResult _getClassicBmiClassification(double bmi) {
    if (bmi < 18.5)
      return BmiResult(
          value: bmi, classification: "Sottopeso", color: Colors.blue);
    if (bmi < 25)
      return BmiResult(
          value: bmi, classification: "Normopeso", color: Colors.green);
    if (bmi < 30)
      return BmiResult(
          value: bmi, classification: "Sovrappeso", color: Colors.orange);
    return BmiResult(value: bmi, classification: "Obesità", color: Colors.red);
  }

  static BmiResult _getPonderalClassification(double pi) {
    // Classificazione indicativa per l'indice ponderale
    if (pi < 11)
      return BmiResult(
          value: pi, classification: "Sottopeso", color: Colors.blue);
    if (pi <= 15)
      return BmiResult(
          value: pi, classification: "Normopeso", color: Colors.green);
    return BmiResult(
        value: pi, classification: "Sovrappeso", color: Colors.orange);
  }
}
