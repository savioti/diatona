import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../data/roadmap_providers.dart';
import '../domain/roadmap_models.dart';
import 'roadmap_selection_screen.dart';
import 'widgets/topic_drawer.dart';

class RoadmapScreen extends ConsumerWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roadmapAsync = ref.watch(roadmapProvider);

    return roadmapAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
          body: Center(
              child: Text(AppLocalizations.of(context).rmLoadError(e.toString())))),
      data: (roadmap) {
        if (roadmap == null) return const RoadmapSelectionScreen();
        return _RoadmapContent(roadmap: roadmap);
      },
    );
  }
}

class _RoadmapContent extends ConsumerWidget {
  const _RoadmapContent({required this.roadmap});

  final Roadmap roadmap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final completedIds = ref.watch(roadmapProgressProvider);
    final totalTopics = roadmap.totalTopics;
    final completedCount = roadmap.sections
        .expand((s) => s.topics)
        .where((t) => completedIds.contains(t.id))
        .length;

    final progress = totalTopics == 0 ? 0.0 : completedCount / totalTopics;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              title: roadmap.title,
              onChangeRoadmap: () => _changeRoadmap(context, ref),
            ),
            _ProgressHeader(
              completedCount: completedCount,
              totalTopics: totalTopics,
              progress: progress,
              cs: cs,
            ),
            Expanded(
              child: _PathList(roadmap: roadmap),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeRoadmap(BuildContext context, WidgetRef ref) async {
    await ref.read(roadmapProvider.notifier).clearSelection();
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const RoadmapSelectionScreen(),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onChangeRoadmap});

  final String title;
  final VoidCallback onChangeRoadmap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            iconSize: 28,
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
          ),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton.icon(
            onPressed: onChangeRoadmap,
            icon: const Icon(Icons.swap_horiz_rounded),
            label: Text(AppLocalizations.of(context).rmChangeRoadmap),
          ),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.completedCount,
    required this.totalTopics,
    required this.progress,
    required this.cs,
  });

  final int completedCount;
  final int totalTopics;
  final double progress;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).rmTopicsCompleted(completedCount, totalTopics),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: cs.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _PathList extends StatelessWidget {
  const _PathList({required this.roadmap});

  final Roadmap roadmap;

  @override
  Widget build(BuildContext context) {
    // Build a flat list: section header + topic nodes interleaved.
    final items = <_PathItem>[];
    for (final section in roadmap.sections) {
      items.add(_PathItem.section(section));
      for (final topic in section.topics) {
        items.add(_PathItem.topic(topic, roadmap.id));
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      itemCount: items.length,
      itemBuilder: (context, index) => items[index].build(context),
    );
  }
}

class _PathItem {
  _PathItem.section(this.section)
      : topic = null,
        roadmapId = '';

  _PathItem.topic(RoadmapTopic t, String rId)
      : topic = t,
        roadmapId = rId,
        section = null;

  final RoadmapSection? section;
  final RoadmapTopic? topic;
  final String roadmapId;

  Widget build(BuildContext context) {
    if (section != null) {
      return _SectionDivider(section: section!);
    }
    return _TopicNode(topic: topic!, roadmapId: roadmapId);
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.section});

  final RoadmapSection section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  section.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
              ),
              if (section.difficulty.isNotEmpty)
                _DifficultyBadge(section.difficulty),
            ],
          ),
          if (section.shortDescription.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              section.shortDescription,
              style: theme.textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 8),
          Divider(color: cs.outline.withAlpha(80), thickness: 1),
        ],
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge(this.difficulty);

  final String difficulty;

  static Color _color(String d) => switch (d) {
        'beginner' => const Color(0xFF4CAF50),
        'intermediate' => const Color(0xFFFF9800),
        'advanced' => const Color(0xFFF44336),
        _ => const Color(0xFF9E9E9E),
      };

  @override
  Widget build(BuildContext context) {
    final color = _color(difficulty);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TopicNode extends ConsumerWidget {
  const _TopicNode({required this.topic, required this.roadmapId});

  final RoadmapTopic topic;
  final String roadmapId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final completed = ref.watch(roadmapProgressProvider).contains(topic.id);

    return GestureDetector(
      onTap: () => _openDrawer(context),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            // Path line + circle indicator column
            SizedBox(
              width: 32,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: completed ? cs.primary : Colors.transparent,
                    border: Border.all(
                      color: completed ? cs.primary : cs.outline,
                      width: 2,
                    ),
                  ),
                  child: completed
                      ? Icon(Icons.check, size: 14, color: cs.onPrimary)
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: completed
                      ? cs.primary.withAlpha(20)
                      : cs.primaryContainer.withAlpha(120),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: completed
                        ? cs.primary.withAlpha(100)
                        : cs.outline.withAlpha(60),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topic.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: completed
                                  ? cs.primary
                                  : cs.onSurface,
                            ),
                          ),
                          if (topic.shortDescription.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              topic.shortDescription,
                              style: theme.textTheme.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: cs.onSurface.withAlpha(120),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDrawer(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: AppLocalizations.of(context).rmDismiss,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, _, _) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {}, // absorb taps inside drawer
          child: TopicDrawer(topic: topic, roadmapId: roadmapId),
        ),
      ),
      transitionBuilder: (_, anim, _, child) {
        final offset = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut));
        return SlideTransition(position: offset, child: child);
      },
    );
  }
}
