import 'package:flutter/material.dart';

import '../../../../features/trainer/domain/chord_type.dart';

class LevelSelector extends StatefulWidget {
  const LevelSelector({
    super.key,
    required this.selectedLevel,
    required this.onLevelChanged,
  });

  final int selectedLevel;
  final ValueChanged<int> onLevelChanged;

  @override
  State<LevelSelector> createState() => _LevelSelectorState();
}

class _LevelSelectorState extends State<LevelSelector> {
  late final ScrollController _scrollController;
  double _itemWidth = 44;

  static const double _separatorWidth = 8;
  static const double _targetItemWidth = 44;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  void _scrollToSelected() {
    final stride = _itemWidth + _separatorWidth;
    final offset = (widget.selectedLevel - 1) * stride;
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  double _computeItemWidth(double availableWidth) {
    const approxStride = _targetItemWidth + _separatorWidth;
    final n = ((availableWidth - _targetItemWidth / 2) / approxStride).floor();
    return (availableWidth - n * _separatorWidth) / (n + 0.5);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final levels = ChordType.values.length;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 48,
      child: LayoutBuilder(
        builder: (context, constraints) {
          _itemWidth = _computeItemWidth(constraints.maxWidth);
          return ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: levels,
            separatorBuilder: (_, _) =>
                const SizedBox(width: _separatorWidth),
            itemBuilder: (context, index) {
              final level = index + 1;
              final isSelected = level == widget.selectedLevel;
              return GestureDetector(
                onTap: () => widget.onLevelChanged(level),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _itemWidth,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? Border.all(color: colorScheme.primary, width: 2)
                        : null,
                  ),
                  child: Text(
                    '$level',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
