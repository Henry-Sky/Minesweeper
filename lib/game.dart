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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // reset button
                Container(
                  width: 150, height: 35,
                  decoration: const BoxDecoration(
                    color: resetcolor,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: IconButton(onPressed: () {
                      setState(() {
                        ref.read(boardManager.notifier).initGame();
                      });
                    }, icon: const Icon(Icons.refresh),
                  ),
                ),
                const SizedBox(width: 15),
                // grab button
                Container(
                  width: 90, height: 35,
                  decoration: BoxDecoration(
                      color: ref.watch(boardManager).grab ? selectedcolor : grabcolor,
                      borderRadius: const BorderRadius.all(Radius.circular(30))
                    ),
                  child: IconButton(onPressed: () {
                      setState(() {
                        ref.read(boardManager).grab = !ref.read(boardManager).grab;
                        ref.read(boardManager).flag = false;
                      });
                    }, icon: const Icon(Icons.directions_walk),
                  )
                ),
                const SizedBox(width: 15),
                // flag button
                Container(
                    width: 90, height: 35,
                    decoration: BoxDecoration(
                      color: ref.watch(boardManager).flag ? selectedcolor : flagcolor,
                        borderRadius: const BorderRadius.all(Radius.circular(30))
                    ),
                    child: IconButton(onPressed: () {
                        setState(() {
                          ref.read(boardManager).flag = !ref.read(boardManager).flag;
                          ref.read(boardManager).grab = false;
                        });
                      }, icon: const Icon(Icons.flag))
                ),
              ],
            ),
            Center(
              child: Stack(
                  children: [
                    GameBoard(refresh: updateGame),
                    GameInfo(resetGame: resetGame),
                  ])
            ),
          ],
        )
      );
  }
}