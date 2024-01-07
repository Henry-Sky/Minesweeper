import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../management/gamelogic.dart';
import '../components/cell.dart';
import '../theme/colors.dart';

class GameBoard extends ConsumerWidget {
  const GameBoard({super.key, required this.refresh});
  final void Function() refresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: boardwidth,
      height: boardheight,
      decoration: BoxDecoration(
          color: boardcolor,
          border: Border.all(
            color: boardroundcolor,
            width: borderwidth,
          ),
          borderRadius: const BorderRadius.all(
              Radius.circular(borderwidth),
          )
      ),
      child: Stack(
          children: List.generate(boardrows * boardcols, (i) {
            var col = i % boardcols;
            var row = (i / boardcols).floor();
            return Positioned(
                left: col * cellwidth,
                top: row * cellwidth,
                child: CellWidget(row: row, col: col, refresh: refresh),
            );
          })
      ),
    );
  }
}
