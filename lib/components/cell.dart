import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/colors.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/management/gamelogic.dart';

class CellWidget extends ConsumerStatefulWidget{
  CellWidget({this.row,this.col});
  late final row;
  late final col;


  @override
  ConsumerState<ConsumerStatefulWidget> createState()
  => _CellWidget(row: row, col: col);
}

class _CellWidget extends ConsumerState<CellWidget> {
  _CellWidget({required this.row,this.col});
  late final row;
  late final col;

  @override
  Widget build(BuildContext context) {
      switch(ref.watch(boardManager).mineboard[row][col]["state"]){
        case cellstate.covered:
          return Container(
            width: cellwidth, height: cellwidth,
            decoration: BoxDecoration(
              color: cellcolor,
              border: Border.all(width: 2,color: cellroundcolor)
            ),
            child: MaterialButton(onPressed: () {
                if(ref.read(boardManager).grab){
                  setState(() {
                    ref.read(boardManager).mineboard[row][col]["state"] = cellstate.blank;
                  });
                }else if(ref.read(boardManager).flag){
                  setState(() {
                    ref.read(boardManager).mineboard[row][col]["state"] = cellstate.flaged;
                  });}
              },
            ),
          );

        case cellstate.blank:
          if(ref.read(boardManager).mineboard[row][col]["mine"]){
            return Container(
              width: cellwidth, height: cellwidth,
              color: boardcolor,
              child: Icon(Icons.gps_fixed,color: Colors.red,),
            );
          }else{
            setState(() {
              ref.watch(boardManager).mineboard[row+1<cellrows?row+1:cellrows-1][col]["state"];
              ref.watch(boardManager).mineboard[row-1>=0?row-1:0][col]["state"]=cellstate.blank;
            });
            return Container(
              width: cellwidth, height: cellwidth,
              color: boardcolor,
            );
          }

        case cellstate.flaged:
          return Container(
            width: cellwidth, height: cellwidth,
            decoration: BoxDecoration(
                color: cellcolor,
                border: Border.all(width: 2,color: cellroundcolor)
            ),
            child: Stack(
              children: [
                Icon(Icons.flag),
                MaterialButton(onPressed: () {
                  if(ref.read(boardManager).grab){
                    setState(() {
                      ref.read(boardManager).mineboard[row][col]["state"] = cellstate.blank;
                    });
                  }else if(ref.read(boardManager).flag){
                    setState(() {
                      ref.read(boardManager).mineboard[row][col]["state"] = cellstate.covered;
                    });
                  }
                },),
              ],
            )
          );

        default:
          return Container(width: cellwidth,height: cellwidth);
      }
  }
}