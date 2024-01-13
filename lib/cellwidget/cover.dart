import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../management/gamelogic.dart';
import '../theme/colors.dart';

class CellCover extends ConsumerWidget {
  const CellCover({
    super.key,
    required this.visible,
  });

  final duration = Durations.medium4;
  final curve = Curves.ease;
  final bool visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = ref.read(boardManager).screen;
    final cellWidth = screen.getCellWidth();
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      curve: curve,
      duration: duration,
      child: Container(
        width: cellWidth,
        height: cellWidth,
        decoration: BoxDecoration(
          color: coverColor,
          border: Border.all(
            width: 1,
            color: boardColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
                screen.getBoardRadius(),
            ),
          ),
        ),
      ),
    );
  }
}
