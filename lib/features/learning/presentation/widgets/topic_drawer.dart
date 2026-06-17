import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../data/roadmap_providers.dart';
import '../../domain/roadmap_models.dart';
import '../quiz_screen.dart';

class TopicDrawer extends ConsumerWidget {
  const TopicDrawer({
    super.key,
    required this.topic,
    required this.roadmapId,
  });

  final RoadmapTopic topic;
  final String roadmapId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final completed = ref.watch(roadmapProgressProvider).contains(topic.id);

    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {},
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: Material(
            color: cs.surface,
            elevation: 8,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 48, 20, 8),
                    child: _DrawerContent(topic: topic),
                  ),
                ),
                _BottomActions(
                  topic: topic,
                  completed: completed,
                  onToggle: () =>
                      ref.read(roadmapProgressProvider.notifier).toggle(topic.id),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerContent extends StatelessWidget {
  const _DrawerContent({required this.topic});

  final RoadmapTopic topic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          topic.title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            if (topic.difficulty.isNotEmpty)
              _Badge(topic.difficulty, cs.primary, cs.onPrimary),
            if (topic.difficulty.isNotEmpty && !topic.estimatedTime.isEmpty)
              const SizedBox(width: 8),
            if (!topic.estimatedTime.isEmpty)
              _Badge(
                '${topic.estimatedTime.min}–${topic.estimatedTime.max} ${topic.estimatedTime.unit}',
                cs.secondaryContainer,
                cs.onSecondaryContainer,
              ),
          ],
        ),
        if (topic.shortDescription.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(topic.shortDescription, style: theme.textTheme.bodyMedium),
        ],
        if (topic.longDescription.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(topic.longDescription, style: theme.textTheme.bodyMedium),
        ],
        if (topic.objectives.isNotEmpty) ...[
          _SectionHeader(l10n.rmObjectives),
          _BulletList(topic.objectives),
        ],
        if (topic.commonMistakes.isNotEmpty) ...[
          _SectionHeader(l10n.rmCommonMistakes),
          _BulletList(topic.commonMistakes),
        ],
        if (topic.practiceTips.isNotEmpty) ...[
          _SectionHeader(l10n.rmPracticeTips),
          _BulletList(topic.practiceTips),
        ],
        if (topic.tags.isNotEmpty) ...[
          _SectionHeader(l10n.rmTags),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: topic.tags
                .map(
                  (t) => Chip(
                    label: Text(t),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
        ],
        if (topic.resources.isNotEmpty) ...[
          _SectionHeader(l10n.rmResources),
          ...topic.resources.map((r) => _ResourceTile(resource: r)),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.label, this.bg, this.fg);

  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList(this.items);

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(item, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ResourceTile extends StatelessWidget {
  const _ResourceTile({required this.resource});

  final TopicResource resource;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Badge(resource.type, cs.tertiaryContainer, cs.onTertiaryContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _openUrl(resource.url),
                  child: Text(
                    resource.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: cs.primary,
                    ),
                  ),
                ),
                if (resource.durationInMinutes != null &&
                    resource.durationInMinutes! > 0)
                  Text(
                    '${resource.durationInMinutes} min',
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.topic,
    required this.completed,
    required this.onToggle,
  });

  final RoadmapTopic topic;
  final bool completed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final hasQuiz = topic.assessments.isNotEmpty;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasQuiz) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _openQuiz(context),
                  icon: const Icon(Icons.quiz_outlined),
                  label: Text(l10n.rmTakeQuiz),
                ),
              ),
              const SizedBox(height: 8),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onToggle,
                icon: Icon(
                  completed
                      ? Icons.remove_circle_outline
                      : Icons.check_circle_outline,
                ),
                label: Text(
                    completed ? l10n.rmMarkIncomplete : l10n.rmMarkComplete),
                style: ElevatedButton.styleFrom(
                  backgroundColor: completed ? cs.error : cs.primary,
                  foregroundColor: completed ? cs.onError : cs.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openQuiz(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuizScreen(
          topicTitle: topic.title,
          assessments: topic.assessments,
        ),
      ),
    );
  }
}
