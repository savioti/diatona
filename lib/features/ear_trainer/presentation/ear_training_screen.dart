import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../domain/ear_training_session_state.dart';
import '../domain/interval_direction.dart';
import '../domain/interval_type.dart';
import 'ear_training_provider.dart';
import 'widgets/interval_answer_buttons.dart';
import 'widgets/playback_control.dart';
import 'widgets/session_stats_bar.dart';

class EarTrainingScreen extends ConsumerStatefulWidget {
  const EarTrainingScreen({
    super.key,
    required this.pool,
    required this.direction,
  });

  final List<IntervalType> pool;
  final IntervalDirection direction;

  @override
  ConsumerState<EarTrainingScreen> createState() => _EarTrainingScreenState();
}

class _EarTrainingScreenState extends ConsumerState<EarTrainingScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(earTrainingProvider.notifier)
          .start(widget.pool, widget.direction);
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    ref.read(earTrainingProvider.notifier).stop();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    await ref.read(earTrainingProvider.notifier).stop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final session = ref.watch(earTrainingProvider);

    return PopScope(
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) await _onWillPop();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Header row: back + stats
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

                // Main content area
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Phase display
                      Expanded(
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _PhaseDisplay(
                              key: ValueKey(session.phase),
                              session: session,
                              l10n: l10n,
                              theme: theme,
                            ),
                          ),
                        ),
                      ),

                      // Playback control
                      PlaybackControl(
                        phase: session.phase,
                        onPlay: () =>
                            ref.read(earTrainingProvider.notifier).replay(),
                      ),
                      const SizedBox(height: 24),

                      // Answer buttons
                      if (session.phase != EarTrainingPhase.idle)
                        IntervalAnswerButtons(
                          pool: session.pool,
                          phase: session.phase,
                          answeredInterval: session.answeredInterval,
                          correctInterval: session.question?.interval,
                          onAnswer: (interval) => ref
                              .read(earTrainingProvider.notifier)
                              .submitAnswer(interval),
                        ),

                      const SizedBox(height: 16),

                      // Next button — only in showingResult phase
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        child:
                            session.phase == EarTrainingPhase.showingResult
                                ? Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 8),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: ElevatedButton(
                                        onPressed: () => ref
                                            .read(earTrainingProvider.notifier)
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

// ---------------------------------------------------------------------------
// Phase-based center display
// ---------------------------------------------------------------------------

class _PhaseDisplay extends StatelessWidget {
  const _PhaseDisplay({
    super.key,
    required this.session,
    required this.l10n,
    required this.theme,
  });

  final EarTrainingSessionState session;
  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    switch (session.phase) {
      case EarTrainingPhase.idle:
        return const SizedBox.shrink();

      case EarTrainingPhase.playing:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.music_note_rounded,
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

      case EarTrainingPhase.waitingForAnswer:
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
              l10n.earTrainerWhatInterval,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(160),
              ),
            ),
          ],
        );

      case EarTrainingPhase.showingResult:
        final isCorrect = session.isCorrect ?? false;
        final correctInterval = session.question?.interval;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isCorrect
                  ? Icons.check_circle_rounded
                  : Icons.cancel_rounded,
              size: 72,
              color: isCorrect ? Colors.green.shade600 : Colors.red.shade600,
            ),
            const SizedBox(height: 12),
            Text(
              isCorrect ? l10n.correct : l10n.earTrainerWrong,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: isCorrect ? Colors.green.shade600 : Colors.red.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!isCorrect && correctInterval != null) ...[
              const SizedBox(height: 6),
              Text(
                _intervalFullName(correctInterval, l10n),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(200),
                ),
              ),
            ],
          ],
        );
    }
  }
}

// ---------------------------------------------------------------------------
// Full interval name from l10n
// ---------------------------------------------------------------------------

String _intervalFullName(IntervalType t, AppLocalizations l10n) =>
    switch (t) {
      IntervalType.minSecond => l10n.intervalMinSecond,
      IntervalType.majSecond => l10n.intervalMajSecond,
      IntervalType.minThird => l10n.intervalMinThird,
      IntervalType.majThird => l10n.intervalMajThird,
      IntervalType.perfectFourth => l10n.intervalPerfectFourth,
      IntervalType.tritone => l10n.intervalTritone,
      IntervalType.perfectFifth => l10n.intervalPerfectFifth,
      IntervalType.minSixth => l10n.intervalMinSixth,
      IntervalType.majSixth => l10n.intervalMajSixth,
      IntervalType.minSeventh => l10n.intervalMinSeventh,
      IntervalType.majSeventh => l10n.intervalMajSeventh,
      IntervalType.octave => l10n.intervalOctave,
    };
