# FitCalc - Calcolatore BMI Avanzato in Flutter

## Descrizione

**FitCalc** è un'applicazione mobile cross-platform, sviluppata in **Flutter**, che funge da caso di studio pratico per la sezione "Deployment" del mio un corso su Udemy di Flutter e Dart. 

[Flutter e Dart: Crea App Android e iOS da Zero](https://www.udemy.com/course/flutter-dart-app-android-ios/)

L'app è un calcolatore di Indice di Massa Corporea (BMI) completo e funzionale, progettato non solo per essere utile, ma anche per dimostrare le migliori pratiche di sviluppo, architettura e preparazione al rilascio di un'applicazione reale sugli store.

Questo repository contiene il codice sorgente completo e accompagna lo studente attraverso ogni fase del ciclo di vita di un'app: dalla scrittura del codice alla pubblicazione e manutenzione.

---

## Funzionalità Principali

* **Calcolo Multi-Formula:** calcola il BMI utilizzando tre diversi metodi scientifici per una visione più completa;
* **Interfaccia Utente Moderna:** UI pulita, reattiva e intuitiva costruita seguendo i principi di Material 3;
* **Tema Chiaro e Scuro:** supporto completo per il tema di sistema;
* **State Management Professionale:** utilizzo del pattern `StateNotifier` con **Riverpod** per una gestione dello stato scalabile e disaccoppiata;
* **Architettura Pulita:** codice organizzato per feature, con una chiara separazione tra UI, logica di business e modelli di dati;
* **Test di Qualità:** include test unitari per garantire l'affidabilità della logica di calcolo.

---

## Stack Tecnologico

* **Framework:** [Flutter](https://flutter.dev/);
* **Linguaggio:** [Dart](https://dart.dev/);
* **State Management:** [Riverpod](https://riverpod.dev/);
* **Backend Services (Analytics & Crash Reporting):** [Firebase](https://firebase.google.com/);
* **Testing:** [flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html).

---

## Come Iniziare

Per eseguire questo progetto in locale, segui questi passaggi:

1.  **Clona il repository**

2.  **Naviga nella cartella del progetto:**
    ```bash
    cd fitcalc
    ```

3.  **Installa le dipendenze:**
    ```bash
    flutter pub get
    ```

4.  **Esegui l'applicazione:**
    ```bash
    flutter run
    ```

---

## Scopo Didattico

Questo progetto è stato creato come materiale di supporto per il mio corso di Flutter. Il suo obiettivo primario è quello di fornire un esempio pratico e completo di come preparare un'applicazione Flutter per il mondo reale, coprendo argomenti come:

* Creazione di build di release (`.aab`)
* Firma digitale dell'app (App Signing)
* Offuscamento del codice
* Creazione di asset per gli store (icone, screenshot)
* Continuous Integration (CI) con GitHub Actions
* Integrazione di Firebase (Analytics & Crashlytics)
* Versioning e manutenzione dell'app
