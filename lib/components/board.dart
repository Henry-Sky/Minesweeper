import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/components/cell.dart';
import 'package:minesweeper/colors.dart';
import 'package:minesweeper/management/gamelogic.dart';


class GameBoard extends ConsumerWidget {
  GameBoard({super.key});

  final roundwidth = 5.0;
  late final boardwidth;
  late final boardheight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    boardwidth = cellwidth * cellcols + roundwidth * 2;
    boardheight = cellwidth * cellrows + roundwidth * 2;

    return Container(
      width: boardwidth,height: boardheight,
      decoration: BoxDecoration(
        color: boardcolor,
        border: Border.all(
          color: boardroundcolor,
          width: roundwidth,
        ),
        borderRadius: BorderRadius.all(Radius.circular(roundwidth))
      ),
      child: Stack(
        children: List.generate(cellrows * cellcols, (i) {
          var col = i % cellcols;
          var row = (i / cellcols).floor();
          ref.watch(boardManager.select((value) => value.mineboard[row][col]));
          return Positioned(
            left: col * cellwidth * 1.0,
            top: row * cellwidth * 1.0,
            child: CellWidget(row: row,col: col)
        );}
        ),
      ),
    );
  }
}