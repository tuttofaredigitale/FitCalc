// import 'dart:ui';
import 'package:fitcalc/core/models/bmi_formula.dart';
import 'package:fitcalc/core/models/bmi_result.dart';
import 'package:fitcalc/core/models/gender.dart';
import 'package:fitcalc/features/bmi_calculator/providers/bmi_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class BmiView extends ConsumerStatefulWidget {
  const BmiView({super.key});

  @override
  ConsumerState<BmiView> createState() => _BmiViewState();
}

class _BmiViewState extends ConsumerState<BmiView> {
  Gender _selectedGender = Gender.male;

  double _currentHeight = 170.0;
  double _currentWeight = 70.0;
  BmiFormula _selectedFormula = BmiFormula.classic;

  void _calculate() {
    HapticFeedback.mediumImpact();

    FirebaseAnalytics.instance.logEvent(
      name: 'bmi_calculated',
      parameters: {
        'formula_name': _selectedFormula.displayName,
        'user_height': _currentHeight,
        'user_weight': _currentWeight,
      },
    );

    ref.read(bmiProvider.notifier).calculateBmi(
          formula: _selectedFormula,
          weight: _currentWeight,
          height: _currentHeight,
          gender: _selectedGender,
        );
  }

  @override
  Widget build(BuildContext context) {
    final bmiState = ref.watch(bmiProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FitCalc'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Selezione Sesso
              Row(
                children: [
                  Expanded(
                    child: _GenderCard(
                      gender: Gender.male,
                      isSelected: _selectedGender == Gender.male,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() => _selectedGender = Gender.male);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _GenderCard(
                      gender: Gender.female,
                      isSelected: _selectedGender == Gender.female,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() => _selectedGender = Gender.female);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Sezione Input
              Row(
                children: [
                  Expanded(
                    child: _InputCard(
                      title: 'Altezza',
                      unit: 'cm',
                      icon: Icons.straighten,
                      value: _currentHeight,
                      min: 100,
                      max: 220,
                      onChanged: (value) {
                        setState(() {
                          _currentHeight = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _InputCard(
                      title: 'Peso',
                      unit: 'kg',
                      icon: Icons.monitor_weight_outlined,
                      value: _currentWeight,
                      min: 30,
                      max: 180,
                      onChanged: (value) {
                        setState(() {
                          _currentWeight = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sezione Formula
              _FormulaSelector(
                selectedFormula: _selectedFormula,
                onSelectionChanged: (formula) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedFormula = formula;
                  });
                  FirebaseAnalytics.instance.logEvent(
                    name: 'formula_changed',
                    parameters: {
                      'selected_formula': formula.displayName,
                    },
                  );
                },
              ),

              const SizedBox(height: 32),

              // Bottone Calcola
              _CalculateButton(
                isLoading: bmiState.isLoading,
                onPressed: _calculate,
                colorScheme: colorScheme,
              ),

              const SizedBox(height: 24),

              // Sezione Risultato
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                        scale: CurvedAnimation(
                            parent: animation, curve: Curves.easeOutBack),
                        child: child),
                  );
                },
                child: bmiState.result != null
                    ? _ResultCard(
                        key: ValueKey(bmiState.result!.value),
                        result: bmiState.result!)
                    : const _PlaceholderCard(
                        key: ValueKey("placeholder"),
                      ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  final Gender gender;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.gender,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final cardColor = isSelected
        ? colorScheme.primaryContainer // Colore evidente quando selezionato
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);

    final contentColor = isSelected
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant;

    // Utilizziamo AnimatedContainer per rendere la transizione visiva fluida
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        // Assicuriamoci che il colore di sfondo sia applicato qui se non usiamo Material sotto
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        // Aggiungiamo un bordo per maggiore enfasi quando selezionato
        border: isSelected
            ? Border.all(color: colorScheme.primary, width: 2)
            : null,
      ),
      // Utilizziamo Material e InkWell per l'effetto "ripple" al tocco
      child: Material(
        color: Colors.transparent, // Il colore è gestito da AnimatedContainer
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icona e Testo prendono il colore calcolato
                Icon(gender.icon, size: 50, color: contentColor),
                const SizedBox(height: 8),
                Text(
                  gender.displayName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: contentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final String title;
  final String unit;
  final IconData icon;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _InputCard({
    required this.title,
    required this.unit,
    required this.icon,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value.toStringAsFixed(0),
                  style: theme.textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                Text(unit, style: theme.textTheme.bodyLarge),
              ],
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _FormulaSelector extends StatelessWidget {
  final BmiFormula selectedFormula;
  final ValueChanged<BmiFormula> onSelectionChanged;

  const _FormulaSelector(
      {required this.selectedFormula, required this.onSelectionChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      // Allineamento centrato
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Formula di calcolo',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SegmentedButton<BmiFormula>(
          showSelectedIcon: true,
          segments: BmiFormula.values.map((formula) {
            return ButtonSegment<BmiFormula>(
              value: formula,
              label: Text(formula.displayName),
              // Utilizza le icone definite nel tuo enum BmiFormula
              icon: Icon(formula.icon),
            );
          }).toList(),
          selected: {selectedFormula},
          onSelectionChanged: (newSelection) {
            onSelectionChanged(newSelection.first);
          },
        ),
      ],
    );
  }
}

class _CalculateButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final ColorScheme colorScheme;

  const _CalculateButton(
      {required this.isLoading,
      required this.onPressed,
      required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  strokeWidth: 3, color: Colors.white))
          : const Text('Calcola BMI'),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({super.key, required this.result});

  final BmiResult result;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final valueDisplay = result.value.toStringAsFixed(1);

    return Card(
      elevation: 4,
      shadowColor: result.color.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            Text(
              'Il tuo BMI è',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              valueDisplay,
              style: textTheme.displayLarge?.copyWith(
                color: result.color,
                fontWeight: FontWeight.bold,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            Chip(
              label: Text(result.classification),
              backgroundColor: result.color.withValues(alpha: 0.1),
              labelStyle: textTheme.titleMedium?.copyWith(
                color: result.color,
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide(color: result.color.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: 24),
            _BmiMeter(bmiValue: result.value),
          ],
        ),
      ),
    );
  }
}

class _BmiMeter extends StatelessWidget {
  final double bmiValue;
  final double minBmi = 15.0;
  final double maxBmi = 35.0;

  const _BmiMeter({required this.bmiValue});

  @override
  Widget build(BuildContext context) {
    double normalizedPosition = (bmiValue - minBmi) / (maxBmi - minBmi);
    normalizedPosition = normalizedPosition.clamp(0.0, 1.0);

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final cursorX = constraints.maxWidth * normalizedPosition;
            const double cursorWidth = 16.0;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // La barra colorata (Gradient)
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.blue, // Sottopeso
                        Colors.green, // Normale
                        Colors.orange, // Sovrappeso
                        Colors.red, // Obeso
                      ],
                      // Stop normalizzati: 0.175 (18.5), 0.5 (25), 0.75 (30)
                      stops: [0.175, 0.5, 0.75, 1.0],
                    ),
                  ),
                ),
                // Il Cursore
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutExpo,
                  left: cursorX - (cursorWidth / 2),
                  top: -4,
                  child: Container(
                    width: cursorWidth,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black87, width: 3),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        // Etichette della scala
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('15',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            Expanded(
                child: Center(
                    child: Text('Normale (18.5-25)',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500)))),
            Text('35+',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withValues(alpha: 0.3),
      child: const Padding(
        padding: EdgeInsets.all(48.0),
        child: Text(
          'Seleziona i tuoi dati e premi "Calcola" per visualizzare il tuo indice BMI e il relativo spettro.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
