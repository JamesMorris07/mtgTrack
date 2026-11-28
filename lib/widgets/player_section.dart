import 'package:flutter/material.dart';

class PlayerSection extends StatelessWidget {
  final int playerIndex;
  final int lifeTotal;
  final Color playerColor;
  final int quarterTurns;
  final bool allowDragging;

  final Function(int) onLifeChange;
  final Function(int) onDamage;

  const PlayerSection({
    super.key,
    required this.playerIndex,
    required this.lifeTotal,
    required this.playerColor,
    required this.onLifeChange,
    required this.onDamage,
    required this.quarterTurns,
    this.allowDragging = true,
  });

  // Builds the visual ticker shared by both modes
  Widget _buildTicker() {
    return SizedBox.expand(
      child: Container(
        color: playerColor,
        child: Stack(
          children: [
            // Player name in the corner
            Positioned(
              bottom: 12,
              left: (playerIndex == 0 || playerIndex == 2)
                  ? 12
                  : (playerIndex == 4 ? 0 : null),
              right: (playerIndex == 1 || playerIndex == 3)
                  ? 12
                  : (playerIndex == 4 ? 0 : null),
              child: Text(
                'Player ${playerIndex + 1}',
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),

            // Centered life total and controls
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RotatedBox(
        quarterTurns: quarterTurns,
        child: allowDragging
            ? DragTarget<int>(
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
                    child: _buildTicker(),
                  );
                },
              )
            : _buildTicker(),
      ),
    );
  }
}
