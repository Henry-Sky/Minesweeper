import '../components/board.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BoardLogic extends StateNotifier<BoardStates>{
  BoardLogic(this.ref) : super(BoardStates());

  final StateNotifierProviderRef ref;

  void initGame(){
    state.grab = false;
    state.flag = false;
    state.mineboard = newBoard();
  }

  List<List<Map>> newBoard(){
    return List.generate(cellrows, (row) => List.generate(cellcols,(col) =>
    {"is-mine":false, "is-grab":false, "is-flag":false, "around-mine":0}
    ));
  }

  void putMine(board,minenum){
    // get size of board
    var rows = board.length;
    var cols = board[0].length;
  }

  void countMine({row,col}){
    int count = 0;
    int beginrow = row-1<0 ? 0 : row-1;
    int endrow = row+1>=20 ? 19 : row+1;
    int begincol = col-1<0 ? 0 : col-1;
    int endcol = col+1>=14 ? 13 : col+1;
    for(int r=beginrow;r<=endrow;r++){
      for(int c=begincol;c<=endcol;c++){
        if((r!=row&&c!=col)&&state.mineboard[r][c]["is-mine"]){
          count += 1;
        }
      }
    }
    state.mineboard[row][col]["around-mine"] = count;
  }

  void SelectButton(String buttonname){
    if(buttonname == "grab"){
      state.grab = !state.grab;
      state.flag = false;
    }
    else if(buttonname == "flag"){
      state.flag = !state.flag;
      state.grab = false;
    }
  }

}

class BoardStates{
  late var grab;
  late var flag;
  late List<List<Map>> mineboard;
}

final boardManager = StateNotifierProvider<BoardLogic, BoardStates>((ref) {
  return BoardLogic(ref);
});
