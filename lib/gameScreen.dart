import 'package:flutter/material.dart';
import '../game.dart';

class GameScreen extends StatelessWidget {
  final Game game;

  const GameScreen({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MTGtrack - Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Players: ${game.numPlayers}'),
            Text('Starting Life: ${game.startingLife}'),
          ],
        ),
      ),
    );
  }
}