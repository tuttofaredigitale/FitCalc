import 'package:flutter/material.dart';

class BmiResult {
  final double value;
  final String classification;
  final Color color;

  BmiResult({
    required this.value,
    required this.classification,
    required this.color,
  });
}
