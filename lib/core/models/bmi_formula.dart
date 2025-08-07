import 'package:flutter/material.dart';

enum BmiFormula {
  classic,
  oxford,
  ponderal;

  String get displayName {
    switch (this) {
      case BmiFormula.classic:
        return 'Classico';
      case BmiFormula.oxford:
        return 'Nuovo';
      case BmiFormula.ponderal:
        return 'Ponderale';
    }
  }

  IconData get icon {
    switch (this) {
      case BmiFormula.classic:
        return Icons.scale;
      case BmiFormula.oxford:
        return Icons.science_outlined;
      case BmiFormula.ponderal:
        return Icons.square_foot;
    }
  }
}
