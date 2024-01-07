import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../management/mineboard.dart';
import '../management/gamelogic.dart';
import "package:flutter/foundation.dart";
import '../theme/colors.dart';


class CellWidget extends ConsumerWidget{
  const CellWidget({super.key, required this.row, required this.col, required this.refresh});
  final void Function() refresh;
  final int row;
  final int col;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Cell _cell = ref.watch(boardManager.notifier).getCell(row: row, col: col);
    late final _covered;
    late final _flaged;

    switch(_cell.state){
      case cellstate.blank:
        _covered = false;
        _flaged = false;
      case cellstate.covered:
        _covered = true;
        _flaged = false;
      case cellstate.flag:
        _covered = true;
        _flaged = true;
      default:
        if (kDebugMode) {
          logger.log(Level.error, "Wrong Cell State");
        }
    }

    return Stack(
      children: [
        widgetBlank(cell: _cell),
        widgetCover(visible: _covered),
        widgetFlag(visible: _flaged),
        widgetButton(cell: _cell, covered: _covered, flaged: _flaged, ref: ref),
      ],
    );
  }

  Widget widgetButton({required Cell cell, required bool covered, required bool flaged, required ref}){
    if(covered){
      return SizedBox(
        width: cellwidth, height: cellwidth,
        child: MaterialButton(
          onPressed: () {
            if(!flaged){
              ref.read(boardManager.notifier).changeCell(row: row, col: col, state: cellstate.blank);
              ref.read(boardManager.notifier).checkCell(row: row, col: col);
              if (cell.mine) {
                ref.read(boardManager).gameover = true;
              } else if (ref.read(boardManager.notifier).checkWin()) {
                ref.read(boardManager).goodgame = true;
              }
              refresh();
            }else{
              ref.read(boardManager.notifier).changeCell(row: row, col: col, state: cellstate.covered);
              refresh();
            }
          },
          onLongPress: () {
            ref.read(boardManager.notifier).changeCell(row: row, col: col, state: cellstate.flag);
            refresh();
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
              color: flagcolor,
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
        width: cellwidth, height: cellwidth,
        decoration: BoxDecoration(
          color: cellcolor,
          border: Border.all(
              width: 1,
              color: cellroundcolor,
          ),
          borderRadius: const BorderRadius.all(
              Radius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget widgetBlank({required Cell cell}){
    return Container(
      width: cellwidth, height: cellwidth, color: boardcolor,
      child: cell.mine
          ? const Icon(Icons.gps_fixed, color: minecolor)
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