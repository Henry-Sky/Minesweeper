import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/colors.dart';
import 'board.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/management/gamelogic.dart';

class CellWidget extends ConsumerWidget{
  CellWidget({this.row,this.col});

  late final row;
  late final col;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var cellstate = ref.read(boardManager).mineboard[row][col];
    final isgrab = cellstate["is-grab"];
    final isflag = cellstate["is-flag"];
    final ismine = cellstate["is-mine"];
    final aroundmine = cellstate["around-mine"];

    if(!(isgrab||isflag)){
      return Container(
        width: cellwidth * 1.0,height: cellwidth * 1.0,
        decoration: BoxDecoration(
          color: cellcolor,
          border: Border.all(
            width: 3,
            color: cellroundcolor,
          ),
        ),
      );
    }

    else{
      return Container(
        width: cellwidth * 1.0,height: cellwidth * 1.0,
        color: boardcolor,
      );
    }
  }

}