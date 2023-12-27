import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'components/board.dart';
import 'management/gamelogic.dart';
import 'colors.dart';

class MineSweeper extends ConsumerStatefulWidget {
  const MineSweeper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MineSweeperState();
}

class _MineSweeperState extends ConsumerState<MineSweeper> {

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
          title: const Text("MinesSweeper"),
          backgroundColor: appbarcolor,
        ),
        backgroundColor: backgroundcolor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,height: 50,
                  decoration: BoxDecoration(
                    color: resetcolor,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: IconButton(onPressed: () {
                      setState(() {
                        ref.read(boardManager.notifier).initGame();
                      });
                    }, icon: const Icon(Icons.refresh),
  
                  ),
                ),
                const SizedBox(width: 15,),
                Container(
                  width: 90,height: 50,
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
                const SizedBox(width: 15,),
                Container(
                    width: 90,height: 50,
                    decoration: BoxDecoration(
                      color: ref.watch(boardManager).flag ? selectedcolor : flagcolor,
                        borderRadius: const BorderRadius.all(Radius.circular(30))
                    ),
                    child: IconButton(onPressed: () {
                        setState(() {
                          ref.read(boardManager).flag = !ref.read(boardManager).flag;
                          ref.read(boardManager).grab = false;
                        });
                      }, icon: const Icon(Icons.flag),)
                ),
              ],
            ),
            Center(
              child: GameBoard()
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 180,height: 50,color: labelcolor,child: Text("MineSweeper"),),
                Container(width: 180,height: 50,color: timercolor,child: Text("Timer")),
              ],
            ),
          ],
        )
      );
  }
}