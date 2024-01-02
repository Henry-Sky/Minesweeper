import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/management/mineboard.dart';
import 'package:minesweeper/management/gamelogic.dart';
import 'package:minesweeper/theme/colors.dart';
import 'package:flutter/material.dart';


class CellWidget extends ConsumerWidget{
  const CellWidget({super.key,required this.row, required this.col, required this.refresh});
  final Function refresh;
  final int row;
  final int col;
  final cellroundwidth = 2.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var _cell = ref.watch(boardManager.notifier).getCell(row: row, col: col);
    switch (_cell["state"]){
      case cellstate.covered:
        return Container(
          width: cellwidth, height: cellwidth,
          decoration: BoxDecoration(
            color: cellcolor,
            border: Border.all(width: cellroundwidth, color: cellroundcolor),
            borderRadius: BorderRadius.all(Radius.circular(cellroundwidth))
          ),
          child: MaterialButton(onPressed: () {
            if(ref.read(boardManager).grab){
              ref.read(boardManager.notifier).changeCell(row: row, col: col, state: cellstate.blank);
              ref.read(boardManager.notifier).checkCell(row: row, col: col);
              if(_cell["mine"]){
                ref.read(boardManager).gameover = true;
                print("game over!");
              }else if(ref.read(boardManager.notifier).checkWin()){
                ref.read(boardManager).goodgame = true;
                print("good game");
              }
              refresh();
            }else if(ref.read(boardManager).flag){
              ref.read(boardManager.notifier).changeCell(row: row, col: col, state: cellstate.flag);
              refresh();
            }
          },
            child: (
                ref.read(boardManager.notifier).checkBlank(row: row, col: col) &&
                    ref.read(boardManager.notifier).getCell(row: row, col: col)["around"] != 0
            ) ? Text(_cell["around"].toString()):null,
          ),
        );
      case cellstate.flag:
        return Container(
          width: cellwidth, height: cellwidth,
          decoration: BoxDecoration(
              color: cellcolor,
              border: Border.all(width: cellroundwidth, color: cellroundcolor),
              borderRadius: BorderRadius.all(Radius.circular(cellroundwidth))
          ),
          child: Stack(
            children: [
              Icon(Icons.flag),
              MaterialButton(onPressed: () {
                if(ref.read(boardManager).flag){
                  ref.read(boardManager.notifier).changeCell(row: row, col: col, state: cellstate.covered);
                  refresh();
                }
              },),
            ],
          )
          );
      case cellstate.blank:
        var _mine = _cell["mine"];
        if(!_mine) {
          return Container(
              width: cellwidth, height: cellwidth, color: boardcolor);
        }else{
          return Container(
            width: cellwidth, height: cellwidth, color: boardcolor,
            child: const Icon(Icons.gps_fixed)
          );
        }
      default:
        print("Error! the wrong cell state");
        return Container(width: cellwidth,height: cellwidth,color: errorcolor);
    }
  }
}