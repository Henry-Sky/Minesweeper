import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/management/gamelogic.dart';
import 'package:minesweeper/theme/colors.dart';
import 'package:flutter/material.dart';

class GameInfo extends ConsumerWidget{
  const GameInfo({super.key, required this.resetGame});
  final Function resetGame;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lost Game
    if(ref.read(boardManager).gameover){
      return Opacity(opacity: 0.5,
        child: Container(
          // Todo: reset the size
          width:cellwidth * boardcols + 10 ,
          height: cellwidth * boardrows + 10,
          color: Colors.red,
          child: MaterialButton(onPressed: () {
            resetGame();
          },
            child: const Text(
              "Game Over!\n Click To Replay",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 40),
            ),
          ),
        ),
      );
    }
    // Win Game
    else if(ref.read(boardManager).goodgame){
      Opacity(opacity: 0.5,
        child: Container(
          // Todo: reset the size
          width:cellwidth * boardcols + 10 ,
          height: cellwidth * boardrows + 10,
          color: Colors.green,
          child: MaterialButton(onPressed: () {
            resetGame();
          },
            child: const Text(
              "You Are Win!\n Click To Replay",
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 40),
            ),
          ),
        ),
      );
    }
    // Other
    else{
      return const SizedBox.shrink();
    }
    // Default
    return const SizedBox.shrink();
  }
}