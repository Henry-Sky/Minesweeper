import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

const cellwidth = 32.0;
const cellcols = 10;
const cellrows = 15;

enum cellstate{
  covered,
  blank,
  flaged,
}

class BoardLogic extends StateNotifier<BoardStates>{
  BoardLogic(this.ref) : super(BoardStates());

  final StateNotifierProviderRef ref;

  void initGame(){
    state.grab = false;
    state.flag = false;
    state.gameover = false;
    state.goodgame = false;
    state.mineboard = newBoard();
    randomMine(board: state.mineboard);
  }

  List<List<Map>> newBoard(){
    return List.generate(cellrows, (row) => List.generate(cellcols,(col) =>
    {"mine":false, "state":cellstate.covered, "around-mine":0}
    ));
  }

  void randomMine({board, num = (cellcols * cellrows * 0.3)}){
    var cnt = 0;
    while(cnt < num){
      var value = Random().nextInt(cellcols * cellrows);
      var col = value % cellcols;
      var row = (value / cellrows).floor();
      if(!state.mineboard[row][col]["mine"]){
        state.mineboard[row][col]["mine"] = true;
        addMine(row: row,col: col);
        cnt += 1;
      }
    }
  }

  void addMine({row,col}){
    int beginrow = row-1<0 ? 0 : row-1;
    int endrow = row+1>=cellrows ? cellrows-1 : row+1;
    int begincol = col-1<0 ? 0 : col-1;
    int endcol = col+1>=cellcols ? cellcols-1 : col+1;
    for(int r=beginrow;r<=endrow;r++){
      for(int c=begincol;c<=endcol;c++){
        if((r!=row&&c!=col)&&state.mineboard[r][c]["mine"]){
          state.mineboard[r][c]["around-mine"]+=1;
        }
      }
    }
  }


}

class BoardStates{
  late var grab;
  late var flag;
  late List<List<Map>> mineboard;
  late var gameover; // grab a mine
  late var goodgame; // clear all mines
}

final boardManager = StateNotifierProvider<BoardLogic, BoardStates>((ref) {
  return BoardLogic(ref);
});
