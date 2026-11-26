
import 'package:flutter/material.dart';
import '../game.dart';
import '../models/damage_event.dart';
import '../models/debug.dart';
import '../widgets/damage_panel.dart';

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
  // Current life totals stored as a list (player 1 = 0)
  late List<int> playerLifeTotals;

  // History of damage events throughout the game
  final List<DamageEvent> damageHistory = [];

  // Tracks ongoing damage interaction
  int? pendingAttacker;
  int? pendingRecipient;
  int pendingDamage = 0;

  final List<Color> playerColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
  ];

  @override
  void initState() {
    super.initState();

    playerLifeTotals = List.filled(
      widget.game.numPlayers,
      widget.game.startingLife,
    );

    testDebug(playerLifeTotals);
  }

  // Begins a damage interaction
  void beginDamage(int attacker, int recipient) {
    setState(() {
      pendingAttacker = attacker;
      pendingRecipient = recipient;
      pendingDamage = 0;
    });
  }

  // Changes the pending damage amount
  void changeDamage(int amount) {
    setState(() {
      pendingDamage =
          (pendingDamage + amount).clamp(0, 999).toInt();
    });
  }

  // Confirms and records damage
  void confirmDamage() {
    if (pendingAttacker == null ||
        pendingRecipient == null ||
        pendingDamage <= 0) {
      return;
    }

    setState(() {
      // Subtract damage from recipient
      playerLifeTotals[pendingRecipient!] -= pendingDamage;

      // Record damage event
      damageHistory.add(
        DamageEvent(
          attacker: pendingAttacker!,
          recipient: pendingRecipient!,
          amount: pendingDamage,
        ),
      );

      // Reset damage interaction
      pendingAttacker = null;
      pendingRecipient = null;
      pendingDamage = 0;
    });
  }

  // Cancels damage interaction
  void cancelDamage() {
    setState(() {
      pendingAttacker = null;
      pendingRecipient = null;
      pendingDamage = 0;
    });
  }

  // Changes a player's life total
  void changeLife(int player, int amount) {
    setState(() {
      playerLifeTotals[player] += amount;
    });
  }

  // Builds an individual player section
  Widget playerSection(int index) {
    return Expanded(
      child: DragTarget<int>(
        onWillAcceptWithDetails: (details) {
          return details.data != index;
        },

        onAcceptWithDetails: (details) {
          beginDamage(details.data, index);
        },

        builder: (context, candidateData, rejectedData) {
          return Draggable<int>(
            data: index,
            maxSimultaneousDrags: 1,

            feedback: Material(
              color: Colors.transparent,
              child: Container(
                width: 150,
                height: 150,
                color: playerColors[index % playerColors.length],
                child: Center(
                  child: Text(
                    'Player ${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),

            childWhenDragging: Container(
              color: playerColors[index % playerColors.length]
                  .withValues(alpha: 0.4),
              child: const Center(
                child: Text(
                  'Attacking...',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          fontSize: 48,
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
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: pendingRecipient != null
            ? Container(
                color: playerColors[
                    pendingRecipient! % playerColors.length],
                width: double.infinity,
                child: DamagePanel(
                  damage: pendingDamage,
                  onIncrease: () => changeDamage(1),
                  onDecrease: () => changeDamage(-1),
                  onConfirm: confirmDamage,
                  onCancel: cancelDamage,
                ),
              )
            : Column(
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

                  if (widget.game.numPlayers == 5) ...[
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
                          playerSection(4),
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
