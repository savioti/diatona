import 'package:flutter/material.dart';

/// Animated overlay used in training screens for success and skip feedback.
///
/// Place inside a [Stack] with [Positioned.fill] semantics — the widget
/// handles its own [Positioned.fill], [IgnorePointer], and [AnimatedOpacity].
class TrainingOverlay extends StatelessWidget {
  const TrainingOverlay({
    super.key,
    required this.show,
    required this.color,
    required this.icon,
    required this.title,
    this.label,
  });

  final bool show;
  final Color color;
  final IconData icon;
  final String title;

  /// Optional subtitle shown below [title] — typically the chord or note name.
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !show,
        child: AnimatedOpacity(
          opacity: show ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 150),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: ColoredBox(
              color: color,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 72),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (label != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      label!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
