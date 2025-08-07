// lib/features/bmi_calculator/providers/bmi_provider.dart

import 'package:fitcalc/core/models/bmi_formula.dart';
import 'package:fitcalc/core/models/bmi_result.dart';
// 1. IMPORTANTE: Aggiungi l'import per Gender (assicurati che il percorso sia corretto)
import 'package:fitcalc/core/models/gender.dart';
import 'package:fitcalc/features/bmi_calculator/services/bmi_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Lo stato rimane lo stesso
class BmiState {
  final BmiResult? result;
  final bool isLoading;

  BmiState({this.result, this.isLoading = false});

  // Manteniamo il tuo copyWith per aggiornamenti parziali
  BmiState copyWith({BmiResult? result, bool? isLoading}) {
    return BmiState(
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Il Notifier si aggiorna
class BmiNotifier extends StateNotifier<BmiState> {
  BmiNotifier() : super(BmiState());

  // 2. AGGIORNAMENTO: Modifica la firma del metodo per includere Gender
  Future<void> calculateBmi({
    required BmiFormula formula,
    required double weight,
    required double height,
    required Gender gender, // Aggiunto qui
  }) async {
    // --- Miglioramento UX: Gestione del caricamento ---

    // Invece di resettare subito il risultato (che causa un salto nella UI),
    // manteniamo il risultato precedente visibile e attiviamo solo il loading.
    // state.copyWith(isLoading: true, result: null) non funzionerebbe comunque a causa del '??' nel copyWith.
    state = state.copyWith(isLoading: true);

    // --------------------------------------------------

    // Simuliamo un caricamento
    await Future.delayed(const Duration(milliseconds: 500));

    BmiResult newResult;
    // Il parametro 'gender' è ora disponibile qui (utile per future espansioni),
    // ma non lo passiamo ai servizi attuali perché non lo richiedono.
    switch (formula) {
      case BmiFormula.classic:
        newResult = BmiService.calculateClassicBmi(weight, height);
        break;
      case BmiFormula.oxford:
        newResult = BmiService.calculateOxfordBmi(weight, height);
        break;
      case BmiFormula.ponderal:
        newResult = BmiService.calculatePonderalIndex(weight, height);
        break;
    }

    // Aggiorniamo lo stato con il nuovo risultato. Creiamo un nuovo stato per assicurarci
    // che il risultato venga aggiornato correttamente, sostituendo quello vecchio.
    state = BmiState(isLoading: false, result: newResult);
  }
}

// Il provider non cambia
final bmiProvider = StateNotifierProvider<BmiNotifier, BmiState>((ref) {
  return BmiNotifier();
});
