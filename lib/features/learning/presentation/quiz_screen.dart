import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../domain/roadmap_models.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.topicTitle,
    required this.assessments,
  });

  final String topicTitle;
  final List<Assessment> assessments;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // questionId → selected optionId
  final Map<String, String> _answers = {};
  bool _submitted = false;

  List<AssessmentQuestion> get _allQuestions =>
      widget.assessments.expand((a) => a.questions).toList();

  int get _correctCount => _allQuestions.where((q) {
        final selected = _answers[q.id];
        return selected != null && q.correctOptionIds.contains(selected);
      }).length;

  bool get _allAnswered =>
      _allQuestions.every((q) => _answers.containsKey(q.id));

  void _submit() => setState(() => _submitted = true);

  void _retake() => setState(() {
        _answers.clear();
        _submitted = false;
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final questions = _allQuestions;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.rmQuiz,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.primary,
                          ),
                        ),
                        Text(
                          widget.topicTitle,
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_submitted)
              _ScoreBanner(correct: _correctCount, total: questions.length),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                itemCount: questions.length,
                itemBuilder: (context, index) => _QuestionCard(
                  index: index,
                  question: questions[index],
                  selectedOptionId: _answers[questions[index].id],
                  submitted: _submitted,
                  onSelect: _submitted
                      ? null
                      : (optionId) => setState(
                            () => _answers[questions[index].id] = optionId,
                          ),
                ),
              ),
            ),
            _BottomBar(
              submitted: _submitted,
              allAnswered: _allAnswered,
              onSubmit: _submit,
              onRetake: _retake,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreBanner extends StatelessWidget {
  const _ScoreBanner({required this.correct, required this.total});

  final int correct;
  final int total;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final perfect = correct == total;
    final color = perfect ? Colors.green : cs.primary;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        border: Border.all(color: color.withAlpha(100)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            perfect ? Icons.emoji_events_rounded : Icons.bar_chart_rounded,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              perfect
                  ? l10n.rmQuizPerfect(correct, total)
                  : l10n.rmQuizScore(correct, total),
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.index,
    required this.question,
    required this.selectedOptionId,
    required this.submitted,
    required this.onSelect,
  });

  final int index;
  final AssessmentQuestion question;
  final String? selectedOptionId;
  final bool submitted;
  final ValueChanged<String>? onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withAlpha(60),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outline.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Q${index + 1}. ${question.questionText}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...question.options.map(
            (opt) => _OptionTile(
              option: opt,
              isSelected: selectedOptionId == opt.id,
              isCorrect: question.correctOptionIds.contains(opt.id),
              submitted: submitted,
              onTap: onSelect == null ? null : () => onSelect!(opt.id),
            ),
          ),
          if (submitted && question.explanation.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: cs.outline.withAlpha(40)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline_rounded,
                      size: 16, color: cs.secondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      question.explanation,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.isSelected,
    required this.isCorrect,
    required this.submitted,
    required this.onTap,
  });

  final QuestionOption option;
  final bool isSelected;
  final bool isCorrect;
  final bool submitted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    Color borderColor;
    Color bgColor;
    Color textColor;
    Widget leading;

    if (!submitted) {
      borderColor = isSelected ? cs.primary : cs.outline.withAlpha(80);
      bgColor = isSelected ? cs.primary.withAlpha(20) : Colors.transparent;
      textColor = cs.onSurface;
      leading = Icon(
        isSelected
            ? Icons.radio_button_checked_rounded
            : Icons.radio_button_unchecked_rounded,
        size: 20,
        color: isSelected ? cs.primary : cs.onSurface.withAlpha(120),
      );
    } else if (isCorrect) {
      borderColor = Colors.green;
      bgColor = Colors.green.withAlpha(20);
      textColor = Colors.green;
      leading = const Icon(Icons.check_circle_rounded,
          size: 20, color: Colors.green);
    } else if (isSelected) {
      borderColor = cs.error;
      bgColor = cs.error.withAlpha(20);
      textColor = cs.error;
      leading = Icon(Icons.cancel_rounded, size: 20, color: cs.error);
    } else {
      borderColor = cs.outline.withAlpha(40);
      bgColor = Colors.transparent;
      textColor = cs.onSurface.withAlpha(100);
      leading = Icon(Icons.radio_button_unchecked_rounded,
          size: 20, color: cs.onSurface.withAlpha(60));
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                option.optionText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  fontWeight:
                      (submitted && isCorrect) ? FontWeight.w600 : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.submitted,
    required this.allAnswered,
    required this.onSubmit,
    required this.onRetake,
  });

  final bool submitted;
  final bool allAnswered;
  final VoidCallback onSubmit;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Row(
          children: [
            if (submitted)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onRetake,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l10n.rmQuizRetake),
                ),
              ),
            if (submitted) const SizedBox(width: 12),
            Expanded(
              flex: submitted ? 2 : 1,
              child: ElevatedButton(
                onPressed: submitted
                    ? () => Navigator.of(context).pop()
                    : allAnswered
                        ? onSubmit
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: submitted ? cs.primary : null,
                  foregroundColor: submitted ? cs.onPrimary : null,
                ),
                child: Text(submitted ? l10n.rmQuizDone : l10n.rmQuizSubmit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
