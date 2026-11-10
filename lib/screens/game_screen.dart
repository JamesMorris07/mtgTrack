import 'package:flutter/material.dart';
import '../game.dart';

class GameScreen extends StatefulWidget {
  final Game game;

  const GameScreen({
    super.key,
    required this.game,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
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
            Text('Players: ${widget.game.numPlayers}'),
            Text('Starting Life: ${widget.game.startingLife}'),
          ],
        ),
      ),
    );
  }
}