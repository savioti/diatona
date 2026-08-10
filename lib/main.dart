import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

import 'app.dart';
import 'core/harmony/data/harmony_data.dart';
import 'core/harmony/data/progression_data.dart';
import 'features/trainer/data/chord_data.dart';
import 'features/trainer/data/chord_database.dart';
import 'features/arpeggio_trainer/data/arpeggio_data.dart';
import 'features/scale_trainer/data/scale_data.dart';
import 'features/trainer/data/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await initChordData();
  await initScaleData();
  await initArpeggioData();
  // Harmony reads the scale degrees, so it follows initScaleData.
  await initHarmonyData();
  await initProgressionData();
  unawaited(ChordDatabase.instance.ensureLoaded());
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const App(),
    ),
  );
}
