import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/harmony/domain/diatonic_chord.dart';
import '../../../core/harmony/presentation/harmony_labels.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/answer_buttons.dart';
import '../../../core/widgets/session_stats_bar.dart';
import '../data/roman_questions.dart';
import '../domain/roman_question.dart';
import '../domain/roman_session_state.dart';
import 'roman_training_provider.dart';

class RomanTrainingScreen extends ConsumerStatefulWidget {
  const RomanTrainingScreen({super.key, required this.config});

  final RomanDrillConfig config;

  @override
  ConsumerState<RomanTrainingScreen> createState() =>
      _RomanTrainingScreenState();
}

class _RomanTrainingScreenState extends ConsumerState<RomanTrainingScreen> {
  /// Held from [initState]: `ref` is off limits once the widget is on its way
  /// out, and reaching for it there throws before the round is stopped.
  late final RomanTrainingNotifier _session;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WakelockPlus.enable();
    _session = ref.read(romanTrainingProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _session.start(widget.config);
    });
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    unawaited(_session.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final session = ref.watch(romanTrainingProvider);
    final question = session.question;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    iconSize: 28,
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  const Spacer(),
                  SessionStatsBar(
                    streak: session.streak,
                    accuracy: session.accuracy,
                    totalCount: session.totalCount,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: question == null
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: _Prompt(
                                session: session,
                                question: question,
                                l10n: l10n,
                                theme: theme,
                              ),
                            ),
                          ),
                          AnswerButtons<DiatonicChord>(
                            values: question.options,
                            labelOf: question.labelOf,
                            answered: session.answered,
                            correct: question.answer,
                            revealed:
                                session.phase == RomanPhase.showingResult,
                            enabled:
                                session.phase == RomanPhase.waitingForAnswer,
                            onAnswer: (chord) => ref
                                .read(romanTrainingProvider.notifier)
                                .submitAnswer(chord),
                          ),
                          const SizedBox(height: 16),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 200),
                            child: session.phase == RomanPhase.showingResult
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: ElevatedButton(
                                        onPressed: () => ref
                                            .read(
                                                romanTrainingProvider.notifier)
                                            .nextQuestion(),
                                        child: Text(l10n.next),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The key, the thing being asked, and once it is over, what the answer was.
class _Prompt extends StatelessWidget {
  const _Prompt({
    required this.session,
    required this.question,
    required this.l10n,
    required this.theme,
  });

  final RomanSessionState session;
  final RomanQuestion question;
  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final revealed = session.phase == RomanPhase.showingResult;
    final isCorrect = session.isCorrect ?? false;
    final answer = question.answer;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          harmonicKeyName(question.key, l10n),
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(170),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          question.kind == RomanQuestionKind.numeralToChord
              ? l10n.romanWhichChord
              : l10n.romanWhichDegree,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(140),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          question.prompt,
          textAlign: TextAlign.center,
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 72,
            height: 1.1,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: revealed ? 1 : 0,
          child: Column(
            children: [
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                size: 40,
                color: isCorrect ? Colors.green.shade600 : Colors.red.shade600,
              ),
              const SizedBox(height: 8),
              Text(
                '${answer.numeral}  ·  ${answer.symbol}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                chordNotesLabel(answer),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(180),
                  letterSpacing: 1,
                ),
              ),
              Text(
                harmonicFunctionName(answer.function, l10n),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
