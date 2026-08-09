import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/training_overlay.dart';
import '../domain/scale_direction.dart';
import '../domain/scale_item.dart';
import '../domain/scale_session_state.dart';
import 'scale_labels.dart';
import 'scale_training_provider.dart';
import 'widgets/scale_display.dart';

class ScaleTrainingScreen extends ConsumerStatefulWidget {
  const ScaleTrainingScreen({
    super.key,
    required this.level,
    required this.timeLimitSeconds,
    required this.direction,
    required this.cumulative,
    required this.naturalRootsOnly,
    required this.showNotes,
  });

  final int level;
  final int timeLimitSeconds;
  final ScaleDirection direction;
  final bool cumulative;
  final bool naturalRootsOnly;

  /// Lists the notes of the scale up front instead of hiding them.
  final bool showNotes;

  @override
  ConsumerState<ScaleTrainingScreen> createState() =>
      _ScaleTrainingScreenState();
}

class _ScaleTrainingScreenState extends ConsumerState<ScaleTrainingScreen>
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
      ref.read(scaleTrainingProvider.notifier).start(
            widget.level,
            widget.timeLimitSeconds,
            widget.direction,
            cumulative: widget.cumulative,
            naturalRootsOnly: widget.naturalRootsOnly,
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
    ref.read(scaleTrainingProvider.notifier).stop();
    Navigator.of(context).pop();
  }

  void _advance() {
    ref.read(scaleTrainingProvider.notifier).advance();
  }

  String _scaleTitle(ScaleItem? scale, AppLocalizations l10n) => scale == null
      ? ''
      : l10n.scaleNameLabel(scale.rootName, scaleTypeName(scale.type, l10n));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(scaleTrainingProvider);
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen<ScaleSessionState>(scaleTrainingProvider, (prev, next) {
      if (next.showSuccess || next.showSkip || !next.isActive) {
        _progressController?.stop();
        return;
      }
      if (!next.isGetReady && next.currentScale != prev?.currentScale) {
        _progressController?.forward(from: 0.0);
      }
    });

    final timeLimitLabel = session.timeLimitSeconds == 0
        ? l10n.noTimeLimit
        : l10n.seconds(session.timeLimitSeconds);
    final directionLabel = scaleDirectionName(session.direction, l10n);
    final title = _scaleTitle(session.currentScale, l10n);

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
                          scaleTypeNameForLevel(session.level, l10n),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: colorScheme.primary),
                        ),
                        Text(
                          '$directionLabel · $timeLimitLabel',
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
                Expanded(
                  child: Stack(
                    children: [
                      ScaleDisplay(
                        scale: session.currentScale,
                        title: title,
                        noteIndex: session.noteIndex,
                        misses: session.misses,
                        showNames: widget.showNotes,
                        isGetReady: session.isGetReady || !session.isActive,
                        getReadyText: l10n.getReady,
                        hintText: widget.showNotes
                            ? l10n.scalePlayInOrder
                            : l10n.scaleFindTheNotes,
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
                        title: l10n.scaleMissed,
                        label: session.currentScale?.noteNames.join(' '),
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
