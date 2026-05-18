import 'package:flutter/material.dart';

class BeatIndicator extends StatelessWidget {
  const BeatIndicator({super.key, required this.beatIndex});

  /// Current beat index (0–3).
  final int beatIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isActive = index == beatIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isActive ? 18 : 12,
          height: isActive ? 18 : 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? colorScheme.tertiary : colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        );
      }),
    );
  }
}
