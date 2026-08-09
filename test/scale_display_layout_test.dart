import 'package:diatona/features/scale_trainer/domain/scale_item.dart';
import 'package:diatona/features/scale_trainer/domain/scale_type.dart';
import 'package:diatona/features/scale_trainer/presentation/widgets/scale_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _names = [
  'Bb', 'C', 'Db', 'Eb', 'F', 'G', 'Ab', 'Bb',
  'Ab', 'G', 'F', 'Eb', 'Db', 'C', 'Bb',
];

const _bbDorian = ScaleItem(
  type: ScaleType.dorian,
  rootName: 'Bb',
  noteNames: _names,
  pitchClasses: [10, 0, 1, 3, 5, 7, 8, 10, 8, 7, 5, 3, 1, 0, 10],
);

Future<void> pumpDisplay(
  WidgetTester tester, {
  required bool showNames,
  int noteIndex = 3,
  int misses = 1,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 80),
              Expanded(
                child: ScaleDisplay(
                  scale: _bbDorian,
                  title: 'Bb Dorian',
                  noteIndex: noteIndex,
                  misses: misses,
                  showNames: showNames,
                  isGetReady: false,
                  getReadyText: 'Get Ready',
                  hintText: 'Play the notes in order',
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    ),
  );
}

void main() {
  setUp(() => TestWidgetsFlutterBinding.ensureInitialized());

  testWidgets('fifteen note scale fits on a small screen', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await pumpDisplay(tester, showNames: true);

    expect(find.text('Bb Dorian'), findsOneWidget);
    expect(find.text('Db'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('hidden notes only appear once they are played', (tester) async {
    await pumpDisplay(tester, showNames: false);

    // Bb C Db are played, the twelve notes still to come stay blank.
    expect(find.text('Bb'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
    expect(find.text('Db'), findsOneWidget);
    expect(find.text('?'), findsNWidgets(12));
  });
}
