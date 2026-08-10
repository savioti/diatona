import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../widgets/answer_buttons.dart';
import '../../widgets/replay_control.dart';
import '../../widgets/session_stats_bar.dart';
import '../domain/harmony_ear_question.dart';
import '../domain/harmony_ear_session_state.dart';
import 'harmony_ear_provider.dart';

/// The listening screen shared by the progression and cadence trainers.
///
/// Everything specific to a trainer arrives in the [HarmonyEarConfig]: the
/// answers on offer, where the next question comes from, and how fast it plays.
class HarmonyEarScreen extends ConsumerStatefulWidget {
  const HarmonyEarScreen({
    super.key,
    required this.config,
    required this.prompt,
  });

  final HarmonyEarConfig config;

  /// What is being asked, e.g. `Which progression?`.
  final String prompt;

  @override
  ConsumerState<HarmonyEarScreen> createState() => _HarmonyEarScreenState();
}

class _HarmonyEarScreenState extends ConsumerState<HarmonyEarScreen> {
  /// Held from [initState]: `ref` is off limits once the widget is on its way
  /// out, and reaching for it there throws before the chords are silenced.
  late final HarmonyEarNotifier _session;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WakelockPlus.enable();
    _session = ref.read(harmonyEarProvider.notifier);
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
    final session = ref.watch(harmonyEarProvider);

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) ref.read(harmonyEarProvider.notifier).stop();
      },
      child: Scaffold(
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
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _PhaseDisplay(
                              key: ValueKey(session.phase),
                              session: session,
                              prompt: widget.prompt,
                              theme: theme,
                              l10n: l10n,
                            ),
                          ),
                        ),
                      ),
                      ReplayControl(
                        isPlaying: session.phase == HarmonyEarPhase.playing,
                        onPlay: () =>
                            ref.read(harmonyEarProvider.notifier).replay(),
                      ),
                      const SizedBox(height: 20),
                      if (session.phase != HarmonyEarPhase.idle)
                        AnswerButtons<HarmonyEarChoice>(
                          values: session.choices,
                          labelOf: (choice) => choice.label,
                          answered: session.choices.firstWhere(
                            (choice) => choice.id == session.answeredId,
                            orElse: () =>
                                const HarmonyEarChoice(id: '', label: ''),
                          ),
                          correct: session.correctChoice,
                          revealed:
                              session.phase == HarmonyEarPhase.showingResult,
                          enabled: session.phase ==
                              HarmonyEarPhase.waitingForAnswer,
                          onAnswer: (choice) => ref
                              .read(harmonyEarProvider.notifier)
                              .submitAnswer(choice),
                        ),
                      const SizedBox(height: 16),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        child: session.phase == HarmonyEarPhase.showingResult
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: () => ref
                                        .read(harmonyEarProvider.notifier)
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
      ),
    );
  }
}

class _PhaseDisplay extends StatelessWidget {
  const _PhaseDisplay({
    super.key,
    required this.session,
    required this.prompt,
    required this.theme,
    required this.l10n,
  });

  final HarmonyEarSessionState session;
  final String prompt;
  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    switch (session.phase) {
      case HarmonyEarPhase.idle:
        return const SizedBox.shrink();

      case HarmonyEarPhase.playing:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.piano_rounded,
                size: 72, color: theme.colorScheme.primary.withAlpha(180)),
            const SizedBox(height: 12),
            Text(
              '♩  ♩  ♩',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary.withAlpha(160),
                letterSpacing: 12,
              ),
            ),
          ],
        );

      case HarmonyEarPhase.waitingForAnswer:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '?',
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 96,
                color: theme.colorScheme.primary,
                height: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              prompt,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(160),
              ),
            ),
          ],
        );

      case HarmonyEarPhase.showingResult:
        final isCorrect = session.isCorrect ?? false;
        final question = session.question;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
              size: 64,
              color: isCorrect ? Colors.green.shade600 : Colors.red.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              isCorrect ? l10n.correct : l10n.earTrainerWrong,
              style: theme.textTheme.titleLarge?.copyWith(
                color: isCorrect ? Colors.green.shade600 : Colors.red.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (question != null) ...[
              const SizedBox(height: 10),
              Text(
                question.keyLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(160),
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final chord in question.chords)
                    Container(
                      constraints: const BoxConstraints(minWidth: 54),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            chord.numeral,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onPrimaryContainer
                                  .withAlpha(170),
                            ),
                          ),
                          Text(
                            chord.symbol,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ],
        );
    }
  }
}
