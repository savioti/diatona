import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../widgets/training_overlay.dart';
import '../domain/note_sequence.dart';
import '../domain/sequence_session_state.dart';
import 'sequence_training_provider.dart';
import 'widgets/sequence_display.dart';

/// The training screen shared by the scale and arpeggio trainers.
///
/// Everything specific to a trainer arrives through the constructor: the pool
/// to draw from, what to call the round, and whether the notes are given away.
class SequenceTrainingScreen extends ConsumerStatefulWidget {
  const SequenceTrainingScreen({
    super.key,
    required this.pool,
    required this.headline,
    required this.subtitle,
    required this.timeLimitSeconds,
    required this.showNames,
  });

  final List<NoteSequence> pool;

  /// Top left label, usually the level.
  final String headline;

  /// Second line under [headline], the options the round runs with.
  final String subtitle;

  final int timeLimitSeconds;

  /// Lists the notes up front instead of hiding them.
  final bool showNames;

  @override
  ConsumerState<SequenceTrainingScreen> createState() =>
      _SequenceTrainingScreenState();
}

class _SequenceTrainingScreenState
    extends ConsumerState<SequenceTrainingScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _progressController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WakelockPlus.enable();

    if (widget.timeLimitSeconds > 0) {
      _progressController = AnimationController(
        vsync: this,
        duration: Duration(seconds: widget.timeLimitSeconds),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(sequenceTrainingProvider.notifier)
          .start(widget.pool, widget.timeLimitSeconds);
    });
  }

  @override
  void dispose() {
    _progressController?.dispose();
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _stop() {
    ref.read(sequenceTrainingProvider.notifier).stop();
    Navigator.of(context).pop();
  }

  void _advance() {
    ref.read(sequenceTrainingProvider.notifier).advance();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sequenceTrainingProvider);
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen<SequenceSessionState>(sequenceTrainingProvider, (prev, next) {
      if (next.showSuccess || next.showSkip || next.showMissed ||
          !next.isActive) {
        _progressController?.stop();
        return;
      }
      if (!next.isGetReady && next.current != prev?.current) {
        _progressController?.forward(from: 0.0);
      }
    });

    final title = session.current?.title ?? '';

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _stop();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.headline,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: colorScheme.primary),
                          ),
                          Text(
                            widget.subtitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: colorScheme.secondary,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.stop_rounded),
                      iconSize: 28,
                      onPressed: _stop,
                      tooltip: l10n.stop,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Stack(
                    children: [
                      SequenceDisplay(
                        sequence: session.current,
                        noteIndex: session.noteIndex,
                        misses: session.misses,
                        showNames: widget.showNames,
                        isGetReady: session.isGetReady || !session.isActive,
                        getReadyText: l10n.getReady,
                        hintText: widget.showNames
                            ? l10n.trainingPlayInOrder
                            : l10n.trainingFindTheNotes,
                      ),
                      TrainingOverlay(
                        show: session.showSuccess,
                        color: Colors.green.withValues(alpha: 0.92),
                        icon: Icons.check_circle_rounded,
                        title: l10n.correct,
                        label: title,
                      ),
                      TrainingOverlay(
                        show: session.showSkip,
                        color: Colors.orange.withValues(alpha: 0.92),
                        icon: Icons.skip_next_rounded,
                        title: l10n.skipped,
                        label: title,
                      ),
                      TrainingOverlay(
                        show: session.showMissed,
                        color: Colors.red.withValues(alpha: 0.92),
                        icon: Icons.close_rounded,
                        title: l10n.trainingMissed,
                        label: session.current?.noteNames.join(' '),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                if (_progressController != null) ...[
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: AnimatedBuilder(
                      animation: _progressController!,
                      builder: (context, _) => CircularProgressIndicator(
                        value: 1.0 - _progressController!.value,
                        strokeWidth: 6,
                        color: colorScheme.tertiary,
                        backgroundColor:
                            colorScheme.onSurface.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                FilledButton.tonal(
                  onPressed:
                      session.isActive && !session.isGetReady ? _advance : null,
                  child: Text(l10n.next),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
