import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../management/cellstate.dart';
import '../management/gamelogic.dart';
import '../theme/colors.dart';

class CellButton extends ConsumerWidget {
  const CellButton({
    super.key,
    required this.cell,
    required this.coverVisible,
    required this.flagVisible,
    required this.refresh,
  });

  final Cell cell;
  final bool coverVisible;
  final bool flagVisible;
  final void Function() refresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.read(boardManager.notifier);
    final screen = ref.read(boardManager).screen;
    final cellWidth = screen.getCellWidth();
    return !(cell.state == CellState.blank && cell.minesAround == 0)
        ? Container(
          width: cellWidth,
          height: cellWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(screen.getBoardRadius()),
            )
          ),
          child: InkWell(
            radius: screen.getBoardRadius(),
            highlightColor: Colors.transparent,
            splashColor: !coverVisible ? Colors.transparent : coverColor,
            onTap: !coverVisible
                ? null
                : () {
                    // Click a Cover Cell => Blank
                    if (!flagVisible) {
                      manager.dig(cell: cell);
                    } else {
                      // Click a Flag Cell => Cancel Flag (Covered)
                      manager.removeFlag(cell: cell);
                    }
                    refresh();
                  },
            onDoubleTap: coverVisible
                ? null
                : () {
                    manager.digAroundBesidesFlagged(cell: cell);
                    manager.flagRestCovered(cell: cell);
                    refresh();
                  },
            onLongPress: !coverVisible
                ? null
                : () {
                    manager.toggleFlag(cell: cell);
                    refresh();
                  },
          ),
        )
        : const SizedBox.shrink();
  }
}
