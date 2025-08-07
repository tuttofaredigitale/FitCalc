import 'package:flutter/material.dart';

enum Gender {
  male,
  female;

  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Uomo';
      case Gender.female:
        return 'Donna';
    }
  }

  IconData get icon {
    switch (this) {
      case Gender.male:
        // Icone standard
        return Icons.male_rounded;
      case Gender.female:
        return Icons.female_rounded;
    }
  }
}
