import 'package:flutter/material.dart';

class PlayerSection extends StatelessWidget {
  final int playerIndex;
  final int lifeTotal;
  final Color playerColor;

  final Function(int) onLifeChange;
  final Function(int) onDamage;

  const PlayerSection({
    super.key,
    required this.playerIndex,
    required this.lifeTotal,
    required this.playerColor,
    required this.onLifeChange,
    required this.onDamage,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DragTarget<int>(
        onWillAcceptWithDetails: (details) {
          return details.data != playerIndex;
        },

        onAcceptWithDetails: (details) {
          onDamage(details.data);
        },

        builder: (context, candidateData, rejectedData) {
          return Draggable<int>(
            data: playerIndex,
            maxSimultaneousDrags: 1,

            feedback: Material(
              color: Colors.transparent,
              child: Container(
                width: 150,
                height: 150,
                color: playerColor,
                child: Center(
                  child: Text(
                    'Player ${playerIndex + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),

            childWhenDragging: Container(
              color: playerColor.withValues(alpha: 0.4),
              child: const Center(
                child: Text(
                  'Attacking...',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            child: Container(
              color: playerColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Player ${playerIndex + 1}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => onLifeChange(-1),
                        icon: const Icon(Icons.remove),
                        color: Colors.black,
                        iconSize: 32,
                      ),

                      Text(
                        '$lifeTotal',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        onPressed: () => onLifeChange(1),
                        icon: const Icon(Icons.add),
                        color: Colors.black,
                        iconSize: 32,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}