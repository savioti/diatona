import 'package:flutter/material.dart';

class SessionStatsBar extends StatelessWidget {
  const SessionStatsBar({
    super.key,
    required this.streak,
    required this.accuracy,
    required this.totalCount,
  });

  final int streak;
  final double accuracy;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.titleMedium?.copyWith(
      color: theme.colorScheme.onSurface,
      fontWeight: FontWeight.w600,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(Icons.local_fire_department_rounded,
            color: theme.colorScheme.secondary, size: 20),
        const SizedBox(width: 4),
        Text('$streak', style: textStyle),
        const SizedBox(width: 16),
        Icon(Icons.check_circle_outline_rounded,
            color: theme.colorScheme.primary, size: 20),
        const SizedBox(width: 4),
        Text(
          totalCount == 0
              ? '—'
              : '${(accuracy * 100).round()}%',
          style: textStyle,
        ),
      ],
    );
  }
}
