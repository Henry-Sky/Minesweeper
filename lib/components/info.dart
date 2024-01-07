import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../management/gamelogic.dart';
import '../management/gametimer.dart';
import '../theme/colors.dart';

class GameInfo extends ConsumerWidget{
  const GameInfo({super.key, required this.resetGame, required this.time});
  final void Function() resetGame;
  final GameTimer time;
  final double opacityValue = 0.8;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Time Over
    if(time.getTime() == "00:00"){
      ref.read(boardManager).gameOver = true;
    }
    // Lost Game
    if(ref.read(boardManager).gameOver){
      time.stopTimer();
      return Opacity(
        opacity: opacityValue,
        child: Container(
          width: cellWidth * boardCols + borderWidth * 2 ,
          height: cellWidth * boardRows + borderWidth * 2,
          decoration: BoxDecoration(
              color: gameOverColor,
              borderRadius: const BorderRadius.all(Radius.circular(borderWidth))
          ),
          child: MaterialButton(
            onPressed: () {
              resetGame();
              },
            child: Text(
              "Game Over!\n Click To Restart",
              style: TextStyle(
                  color: gameOverTextColor,
                  fontSize: 40),
            ),
          ),
        ),
      );
    }
    // Win Game
    else if(ref.read(boardManager).goodGame){
      // The Cost Time Should Be Counted Before Timer Stop
      String wintime = time.getTimeCost();
      time.stopTimer();
      return Opacity(
        opacity: opacityValue,
        child: Container(
          width: cellWidth * boardCols + borderWidth * 2 ,
          height: cellWidth * boardRows + borderWidth * 2,
          decoration: BoxDecoration(
            color: goodGameColor,
            borderRadius: const BorderRadius.all(
                Radius.circular(borderWidth),
            )
          ),
          child: MaterialButton(
            onPressed: () {
              resetGame();
            },
            child: Text(
              " You Win!\n Time: $wintime \n Click To Replay",
              style: TextStyle(
                  color: goodGameTextColor,
                  fontSize: 40
              ),
            ),
          ),
        ),
      );
    }
    // Other
    else{
      return const SizedBox.shrink();
    }
  }
}
