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

  late List<int> playerLifeTotals;

  final List<Color> playerColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();

    playerLifeTotals = List.filled(
      widget.game.numPlayers,
      widget.game.startingLife,
    );
  }

  void changeLife(int player, int amount) {
    setState(() {
      playerLifeTotals[player] += amount;
    });
  }

  Widget playerSection(int index) {
    return Expanded(
      child: Container(
        color: playerColors[index % playerColors.length],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Text(
              'Player ${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                IconButton(
                  onPressed: () => changeLife(index, -1),
                  icon: const Icon(Icons.remove),
                  color: Colors.white,
                  iconSize: 32,
                ),

                Text(
                  '${playerLifeTotals[index]}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                IconButton(
                  onPressed: () => changeLife(index, 1),
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                  iconSize: 32,
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            if (widget.game.numPlayers == 1)
              playerSection(0),

            if (widget.game.numPlayers == 2) ...[
              playerSection(0),
              playerSection(1),
            ],

            if (widget.game.numPlayers == 3) ...[
              Expanded(
                child: Row(
                  children: [
                    playerSection(0),
                    playerSection(1),
                  ],
                ),
              ),
              playerSection(2),
            ],

            if (widget.game.numPlayers == 4) ...[
              Expanded(
                child: Row(
                  children: [
                    playerSection(0),
                    playerSection(1),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    playerSection(2),
                    playerSection(3),
                  ],
                ),
              ),
            ],

          ],
        ),
      ),
    );
  }
}