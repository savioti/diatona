import 'package:diatona/core/sequence_trainer/domain/note_sequence.dart';
import 'package:diatona/core/sequence_trainer/presentation/widgets/sequence_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _bbDorian = NoteSequence(
  id: 'dorian_Bb',
  title: 'Bb Dorian',
  noteNames: [
    'Bb', 'C', 'Db', 'Eb', 'F', 'G', 'Ab', 'Bb',
    'Ab', 'G', 'F', 'Eb', 'Db', 'C', 'Bb',
  ],
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
                child: SequenceDisplay(
                  sequence: _bbDorian,
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
  testWidgets('fifteen note run fits on a small screen', (tester) async {
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
