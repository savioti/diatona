import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../domain/chord_type.dart';
import '../domain/training_session_state.dart';
import 'training_provider.dart';
import 'widgets/chord_display.dart';

class TrainingScreen extends ConsumerStatefulWidget {
  const TrainingScreen({
    super.key,
    required this.level,
    required this.timeLimitSeconds,
    required this.cumulative,
  });

  final int level;
  final int timeLimitSeconds;
  final bool cumulative;

  @override
  ConsumerState<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends ConsumerState<TrainingScreen>
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
      ref.read(trainingProvider.notifier).start(
            widget.level,
            widget.timeLimitSeconds,
            cumulative: widget.cumulative,
          );
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
    ref.read(trainingProvider.notifier).stop();
    Navigator.of(context).pop();
  }

  void _advance() {
    ref.read(trainingProvider.notifier).advance();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(trainingProvider);
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen<TrainingSessionState>(trainingProvider, (prev, next) {
      if (next.showSuccess || !next.isActive) {
        _progressController?.stop();
        return;
      }
      if (!next.isGetReady && next.currentChord != prev?.currentChord) {
        _progressController?.forward(from: 0.0);
      }
    });

    final timeLimitLabel = session.timeLimitSeconds == 0
        ? l10n.noTimeLimit
        : l10n.seconds(session.timeLimitSeconds);

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _levelName(session.level, l10n),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: colorScheme.primary),
                        ),
                        Text(
                          timeLimitLabel,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
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
                Stack(
                  children: [
                    ChordDisplay(
                      chord: session.currentChord,
                      isGetReady: session.isGetReady || !session.isActive,
                      getReadyText: l10n.getReady,
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        ignoring: !session.showSuccess,
                        child: AnimatedOpacity(
                          opacity: session.showSuccess ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 150),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: ColoredBox(
                              color: Colors.green.withValues(alpha: 0.92),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.white,
                                    size: 72,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    l10n.correct,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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

  String _levelName(int level, AppLocalizations l10n) {
    final type =
        ChordType.values[(level - 1).clamp(0, ChordType.values.length - 1)];
    return switch (type) {
      ChordType.major => l10n.levelMajor,
      ChordType.minor => l10n.levelMinor,
      ChordType.aug => l10n.levelAug,
      ChordType.dim => l10n.levelDim,
      ChordType.sus => l10n.levelSus,
      ChordType.seventh => l10n.levelSeventh,
      ChordType.maj7 => l10n.levelMaj7,
      ChordType.m7 => l10n.levelM7,
      ChordType.dim7 => l10n.levelDim7,
      ChordType.halfDim7 => l10n.levelHalfDim7,
      ChordType.mMaj7 => l10n.levelMMaj7,
      ChordType.augMaj7 => l10n.levelAugMaj7,
    };
  }
}
