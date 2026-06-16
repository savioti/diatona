import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/roadmap_providers.dart';
import '../../domain/roadmap_models.dart';

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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final completed =
        ref.watch(roadmapProgressProvider).contains(topic.id);

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
                _CompletionButton(
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
            if (topic.difficulty.isNotEmpty) _Badge(topic.difficulty, cs.primary, cs.onPrimary),
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
          _SectionHeader('Objectives'),
          _BulletList(topic.objectives),
        ],
        if (topic.commonMistakes.isNotEmpty) ...[
          _SectionHeader('Common Mistakes'),
          _BulletList(topic.commonMistakes),
        ],
        if (topic.practiceTips.isNotEmpty) ...[
          _SectionHeader('Practice Tips'),
          _BulletList(topic.practiceTips),
        ],
        if (topic.tags.isNotEmpty) ...[
          _SectionHeader('Tags'),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: topic.tags
                .map((t) => Chip(
                      label: Text(t),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
        ],
        if (topic.resources.isNotEmpty) ...[
          _SectionHeader('Resources'),
          ...topic.resources.map((r) => _ResourceTile(resource: r)),
        ],
        if (topic.assessments.isNotEmpty) ...[
          _SectionHeader('Assessment'),
          ...topic.assessments
              .map((a) => _AssessmentSection(assessment: a)),
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
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
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

class _AssessmentSection extends StatelessWidget {
  const _AssessmentSection({required this.assessment});

  final Assessment assessment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          assessment.title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (assessment.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text(assessment.description,
                style: theme.textTheme.bodyMedium),
          ),
        ...assessment.questions.map((q) => _QuestionCard(
              question: q,
              theme: theme,
              cs: cs,
            )),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.theme,
    required this.cs,
  });

  final AssessmentQuestion question;
  final ThemeData theme;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withAlpha(80),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question.questionText,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...question.options.map((opt) {
            final isCorrect = question.correctOptionIds.contains(opt.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(
                    isCorrect
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 18,
                    color: isCorrect ? Colors.green : cs.onSurface.withAlpha(120),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      opt.optionText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isCorrect ? Colors.green : null,
                        fontWeight: isCorrect ? FontWeight.w600 : null,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          if (question.explanation.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                question.explanation,
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CompletionButton extends StatelessWidget {
  const _CompletionButton({required this.completed, required this.onToggle});

  final bool completed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onToggle,
            icon: Icon(
              completed ? Icons.remove_circle_outline : Icons.check_circle_outline,
            ),
            label: Text(completed ? 'Mark as Incomplete' : 'Mark as Complete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: completed ? cs.error : cs.primary,
              foregroundColor: completed ? cs.onError : cs.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
