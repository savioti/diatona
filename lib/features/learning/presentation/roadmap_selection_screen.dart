import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/roadmap_providers.dart';
import '../data/roadmap_repository.dart';
import '../domain/roadmap_models.dart';
import 'roadmap_screen.dart';

class RoadmapSelectionScreen extends ConsumerWidget {
  const RoadmapSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                iconSize: 28,
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose a Roadmap',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 28,
                  color: cs.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select an instrument or subject to begin your learning path.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: kAvailableRoadmaps.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final option = kAvailableRoadmaps[index];
                    return _RoadmapCard(
                      option: option,
                      onTap: () => _select(context, ref, option),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _select(
    BuildContext context,
    WidgetRef ref,
    RoadmapOption option,
  ) async {
    await ref
        .read(roadmapProvider.notifier)
        .select(option.id, option.filename);

    // Reload progress for the newly selected roadmap.
    ref.read(roadmapProgressProvider.notifier).reload(option.id);

    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const RoadmapScreen()),
    );
  }
}

class _RoadmapCard extends StatelessWidget {
  const _RoadmapCard({required this.option, required this.onTap});

  final RoadmapOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.primaryContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Text(
                option.icon,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.shortDescription,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: cs.primary),
            ],
          ),
        ),
      ),
    );
  }
}
