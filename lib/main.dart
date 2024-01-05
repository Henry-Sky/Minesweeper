import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'game.dart';

void main() {
  runApp(
      const ProviderScope(
          child: GameApp()
      )
  );
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});
  // This widget is the root of game application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MineSweeper',
      home: MineSweeper(),
    );
  }
}


