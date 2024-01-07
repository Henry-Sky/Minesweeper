import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../management/mineboard.dart';
import '../management/gamelogic.dart';
import "package:flutter/foundation.dart";
import '../theme/colors.dart';


class CellWidget extends ConsumerWidget{
  const CellWidget({super.key, required this.row, required this.col, required this.reFresh});
  final void Function() reFresh;
  final int row;
  final int col;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Cell cell = ref.watch(boardManager.notifier).getCell(row: row, col: col);
    late final bool coverCell;
    late final bool flagCell;

    switch(cell.state){
      case cellstate.blank:
        coverCell = false;
        flagCell = false;
      case cellstate.covered:
        coverCell = true;
        flagCell = false;
      case cellstate.flag:
        coverCell = true;
        flagCell = true;
      default:
        if (kDebugMode) {
          logger.log(Level.error, "Wrong Cell State");
        }
    }

    return Stack(
      children: [
        widgetBlank(cell: cell),
        widgetCover(visible: coverCell),
        widgetFlag(visible: flagCell),
        widgetButton(cell: cell, covered: coverCell, flaged: flagCell, ref: ref),
      ],
    );
  }

  Widget widgetButton({required Cell cell, required bool covered, required bool flaged, required ref}){
    if(covered){
      return SizedBox(
        width: cellWidth, height: cellWidth,
        child: MaterialButton(
          onPressed: () {
            // Click a Cover Cell => Blank
            if(!flaged){
              ref.read(boardManager.notifier).changeCell(row: row, col: col, state: cellstate.blank);
              ref.read(boardManager.notifier).checkRoundCell(row: row, col: col);
              // Check Game State
              if (cell.mine) {
                ref.read(boardManager).gameOver = true;
              } else if (ref.read(boardManager.notifier).checkWin()) {
                ref.read(boardManager).goodGame = true;
              }
              reFresh();
            }
            // Click a Flag Cell => Cancel Flag (Covered)
            else{
              ref.read(boardManager.notifier).changeCell(row: row, col: col, state: cellstate.covered);
              reFresh();
            }
          },
          onLongPress: () {
            ref.read(boardManager.notifier).changeCell(row: row, col: col, state: cellstate.flag);
            reFresh();
          },
        ),
      );
    }else{
      return const SizedBox.shrink();
    }
  }

  Widget widgetFlag({required bool visible}){
    const duration = Durations.medium4;
    const curve = Curves.ease;
    return AnimatedPositioned(
      left: 0,
      top: visible ? 0 : -40,
      duration: duration,
      curve: curve,
        child: AnimatedOpacity(
            opacity: visible ? 1 : 0,
            duration: duration,
            curve: curve,
          child: AnimatedScale(
            scale: visible ? 1 : 0.2,
            duration: duration,
            curve: curve,
            child: const Icon(
              Icons.flag,
              size: 40,
              color: flagColor,
            ),
          )
        ),
    );
  }

  Widget widgetCover({required bool visible}){
    const duration = Durations.medium2;
    const curve = Curves.ease;
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      curve: curve,
      duration: duration,
      child: Container(
        width: cellWidth, height: cellWidth,
        decoration: BoxDecoration(
          color: cellColor,
          border: Border.all(
              width: 1,
              color: cellRoundColor,
          ),
          borderRadius: const BorderRadius.all(
              Radius.circular(cellRadius),
          ),
        ),
      ),
    );
  }

  Widget widgetBlank({required Cell cell}){
    return Container(
      width: cellWidth, height: cellWidth, color: boardColor,
      child: cell.mine
          ? const Icon(
          Icons.gps_fixed,
          color: mineColor,
      )
          : numberText(around: cell.around),
    );
  }

  Widget numberText({required int around}){
    if(around == 0){
      return const SizedBox.shrink();
    }
    else {
      return Text(
        around.toString(),
        style: TextStyle(
            color: numcolors[around - 1],
            fontWeight: FontWeight.w900,
            fontSize: 28),
        textAlign: TextAlign.center,);
    }
  }

}