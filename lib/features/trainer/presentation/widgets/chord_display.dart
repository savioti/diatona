import 'package:flutter/material.dart';

import '../../domain/chord.dart';

class ChordDisplay extends StatelessWidget {
  const ChordDisplay({
    super.key,
    required this.chord,
    required this.isGetReady,
    required this.getReadyText,
  });

  final Chord? chord;
  final bool isGetReady;
  final String getReadyText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: screenHeight * 0.4),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),
            child: isGetReady
                ? Text(
                    key: const ValueKey('ready'),
                    getReadyText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      letterSpacing: 2,
                    ),
                  )
                : _ChordLabel(key: ValueKey(chord?.symbol), chord: chord),
          ),
          _DiagramPlaceholder(chord: null),
        ],
      ),
    );
  }
}

class _ChordLabel extends StatelessWidget {
  const _ChordLabel({super.key, required this.chord});

  final Chord? chord;

  @override
  Widget build(BuildContext context) {
    final symbol = chord?.symbol ?? '';
    final alt = chord?.altSymbol;
    const style = TextStyle(
      fontSize: 64,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 2,
    );
    const dividerStyle = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w300,
      color: Colors.white54,
    );

    if (alt == null) {
      return Text(symbol, textAlign: TextAlign.center, style: style);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(symbol, textAlign: TextAlign.center, style: style),
        const Text('/', textAlign: TextAlign.center, style: dividerStyle),
        Text(alt, textAlign: TextAlign.center, style: style),
      ],
    );
  }
}

class _DiagramPlaceholder extends StatelessWidget {
  const _DiagramPlaceholder({required this.chord});

  final Chord? chord;

  @override
  Widget build(BuildContext context) {
    if (chord?.diagramAssetPath == null) return const SizedBox.shrink();
    return const SizedBox.shrink();
  }
}
