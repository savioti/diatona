import 'package:diatona/core/l10n/generated/app_localizations.dart';
import 'package:diatona/features/cadence_trainer/presentation/cadence_home_screen.dart';
import 'package:diatona/features/progression_ear_trainer/presentation/progression_ear_home_screen.dart';
import 'package:diatona/features/progression_trainer/presentation/progression_home_screen.dart';
import 'package:diatona/features/references/presentation/widgets/modulation_widget.dart';
import 'package:diatona/features/references/presentation/widgets/progressions_widget.dart';
import 'package:diatona/features/roman_trainer/presentation/roman_home_screen.dart';
import 'package:diatona/features/trainer/data/providers.dart';
import 'package:diatona/features/trainer/presentation/training_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support.dart';

/// The harmony screens read the data maps while they build, so a screen that
/// looks up a chord it cannot find fails here rather than on a device.
Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: screen),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  setUpAll(() {
    loadScaleDataFromDisk();
    loadChordDataFromDisk();
    loadHarmonyDataFromDisk();
    loadProgressionDataFromDisk();
  });

  testWidgets('the training menu lists every trainer', (tester) async {
    await pumpScreen(tester, const TrainingMenuScreen());

    // Ten cards no longer fit, so the grid has to be scrolled to the bottom.
    for (final label in [
      'Roman Numerals',
      'Progression Trainer',
      'Progression Ear',
      'Cadences',
    ]) {
      await tester.scrollUntilVisible(find.text(label), 200);
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('the progressions reference renders a key of chords',
      (tester) async {
    await pumpScreen(tester, const ProgressionsWidget());

    // C is the key it opens on, so the axis progression reads C G Am F.
    expect(find.text('I'), findsWidgets);
    expect(find.text('Am'), findsWidgets);
  });

  testWidgets('the modulation reference names a pivot in both keys',
      (tester) async {
    await pumpScreen(tester, const ModulationWidget());

    // C major to G major. They share six notes but only four triads, and Am is
    // vi in the one and ii in the other.
    expect(find.text('vi → ii'), findsOneWidget);
    expect(find.text('4 shared chords'), findsOneWidget);
    expect(find.text('1 step apart on the circle of fifths'), findsOneWidget);
    // Dm belongs to C major alone, so it is named once and not twice.
    expect(find.text('ii'), findsOneWidget);
  });

  testWidgets('the progression trainer setup renders', (tester) async {
    await pumpScreen(tester, const ProgressionHomeScreen());
    expect(find.text('Progressions'), findsOneWidget);
    expect(find.text('I  V  vi  IV'), findsOneWidget);
  });

  testWidgets('the roman numeral setup renders', (tester) async {
    await pumpScreen(tester, const RomanHomeScreen());
    expect(find.text('Numeral → Chord'), findsOneWidget);
  });

  testWidgets('the progression ear setup renders', (tester) async {
    await pumpScreen(tester, const ProgressionEarHomeScreen());

    expect(find.text('Progressions'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Tempo'), 200);
    expect(find.text('Tempo'), findsOneWidget);
  });

  testWidgets('the cadence setup offers all four cadences', (tester) async {
    await pumpScreen(tester, const CadenceHomeScreen());

    for (final name in ['Authentic', 'Plagal', 'Half', 'Deceptive']) {
      expect(find.text(name), findsOneWidget);
    }
  });
}
