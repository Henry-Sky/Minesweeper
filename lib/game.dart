import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'components/info.dart';
import 'management/gamelogic.dart';
import 'components/board.dart';
import "package:flutter/foundation.dart";
import 'management/gametimer.dart';
import 'theme/colors.dart';

class Minesweeper extends ConsumerStatefulWidget {
  const Minesweeper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MinesweeperState();
}

class _MinesweeperState extends ConsumerState<Minesweeper> {
  late GameTimer timer;

  void updateGame() {
    setState(() {
      if (kDebugMode) {
        ref.read(boardManager).gameOver
            ? logger.log(Level.info, "Game Over!")
            : null;
        ref.read(boardManager).goodGame
            ? logger.log(Level.info, "Good Game!")
            : null;
      }
    });
  }

  void resetGame() {
    setState(() {
      ref.read(boardManager.notifier).initGame();
      // ReCreate Timer When Game Reset
      timer = GameTimer(timeStart: 180, reFresh: updateGame);
    });
  }

  @override
  void initState() {
    super.initState();
    ref.read(boardManager.notifier).initGame();
    // Create Timer
    timer = GameTimer(timeStart: 180, reFresh: updateGame);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
              "MineSweeper",
          ),
          actions: [
            IconButton(
              onPressed: () {
                resetGame();
              },
              icon: const Icon(
                  Icons.refresh,
              ),
            )
          ],
        ),
        backgroundColor: backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
                child: Stack(children: [
                  GameBoard(reFresh: updateGame),
                  GameInfo(resetGame: resetGame, time: timer),
                ])
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // reset button
                Container(
                    width: boardWidth / 2,
                    height: 22,
                    decoration: BoxDecoration(
                        color: modeColor,
                        borderRadius: const BorderRadius.only(
                            topLeft:
                                Radius.circular(cellRadius),
                            bottomLeft:
                                Radius.circular(cellRadius),
                        ),
                    ),
                    child: const Text(
                      "Level: Easy",
                      textAlign: TextAlign.center,
                    )
                ),
                // The Timer
                Container(
                    width: boardWidth / 2,
                    height: 22,
                    decoration: BoxDecoration(
                        color: timerColor,
                        borderRadius: const BorderRadius.only(
                            topRight:
                                Radius.circular(cellRadius),
                            bottomRight:
                                Radius.circular(cellRadius),
                        ),
                    ),
                    child: Text(
                      "Timer: ${timer.getTime()}",
                      textAlign: TextAlign.center,
                    )
                ),
              ],
            ),
          ],
        )
    );
  }
}
