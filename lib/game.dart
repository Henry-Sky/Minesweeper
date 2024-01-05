import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:minesweeper/components/gameinfo.dart';
import 'management/gamelogic.dart';
import 'components/gameboard.dart';
import 'theme/colors.dart';
import 'dart:async';


class MineSweeper extends ConsumerStatefulWidget {
  const MineSweeper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MineSweeperState();
}

class _MineSweeperState extends ConsumerState<MineSweeper> {

  late final Timer _timer;
  var cnt = 300;

  void updateGame(){
    setState(() {
      if (kDebugMode) {
        logger.log(Level.debug, "global refresh!");
      }
    });
  }

  void resetGame(){
    setState(() {
      ref.read(boardManager.notifier).initGame();
    });
  }

  @override
  void initState(){
    super.initState();
    ref.read(boardManager.notifier).initGame();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      cnt -= 1;
      updateGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
        appBar: AppBar(
          title: const Text("MineSweeper"),
          backgroundColor: appbarcolor,
          actions: [
            IconButton(
                onPressed: (){
                  resetGame();
                },
                icon: const Icon(Icons.refresh),
            )
          ],
        ),
        backgroundColor: backgroundcolor,

        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
                child: Stack(
                    children: [
                      GameBoard(refresh: updateGame),
                      GameInfo(resetGame: resetGame),
                    ])
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // reset button
                Container(
                  width: 160, height: 30,
                  decoration: const BoxDecoration(
                    color: resetcolor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))
                  ),
                  child: Text("Level: easy")
                ),
                // The Timer
                Container(
                  width: 160, height: 30,
                  decoration: const BoxDecoration(
                      color: grabcolor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15), bottomRight: Radius.circular(15))
                    ),
                  child: Text("Timer: $cnt")
                ),
              ],
            ),
          ],
        )
      );
  }
}