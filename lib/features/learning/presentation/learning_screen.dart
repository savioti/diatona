import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/roadmap_providers.dart';
import 'roadmap_screen.dart';
import 'roadmap_selection_screen.dart';

class LearningScreen extends ConsumerWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roadmapAsync = ref.watch(roadmapProvider);

    return roadmapAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const RoadmapSelectionScreen(),
      data: (roadmap) =>
          roadmap == null ? const RoadmapSelectionScreen() : const RoadmapScreen(),
    );
  }
}
