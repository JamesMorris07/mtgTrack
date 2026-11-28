import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../game.dart';
import '../models/damage_event.dart';
import '../models/debug.dart';
import '../widgets/damage_panel.dart';
import '../widgets/player_section.dart';

class GameScreen extends StatefulWidget {
  final Game game;

  const GameScreen({super.key, required this.game});

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
  int getPlayerRotation(int index) {
    switch (widget.game.numPlayers) {
      case 2:
        return index == 0 ? 2 : 0;

      case 3:
        if (index == 0) return 1;
        if (index == 1) return 3;
        return 0;

      case 4:
        return index == 1 || index == 2 ? 2 : 0;
      case 5: //this is gonna be good...
        switch (index) {
          case 0:
            return 1;
          case 1:
            return 1;
          case 2:
            return 3;
          case 3:
            return 3;
          case 4:
            return 0;
        }

      default:
        return 0;
    }
    throw 'player orientation error';
  }

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
    //determine orientation
    if (widget.game.numPlayers <= 3 || widget.game.numPlayers == 5) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    testDebug(playerLifeTotals);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
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
      pendingDamage = (pendingDamage + amount).clamp(0, 999).toInt();
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
    return PlayerSection(
      playerIndex: index,
      lifeTotal: playerLifeTotals[index],
      playerColor: playerColors[index % playerColors.length],
      quarterTurns: getPlayerRotation(index),
      allowDragging: widget.game.numPlayers > 1,

      onLifeChange: (amount) {
        changeLife(index, amount);
      },

      onDamage: (attacker) {
        beginDamage(attacker, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pendingRecipient != null
          ? Container(
              color: playerColors[pendingRecipient! % playerColors.length],
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
                if (widget.game.numPlayers == 1) playerSection(0),

                if (widget.game.numPlayers == 2) ...[
                  playerSection(0),
                  playerSection(1),
                ],

                if (widget.game.numPlayers == 3) ...[
                  Expanded(
                    child: Row(children: [playerSection(0), playerSection(1)]),
                  ),
                  playerSection(2),
                ],

                if (widget.game.numPlayers == 4) ...[
                  // Top row: Players 2 and 3
                  Expanded(
                    child: Row(children: [playerSection(1), playerSection(2)]),
                  ),

                  // Bottom row: Players 1 and 4
                  Expanded(
                    child: Row(children: [playerSection(0), playerSection(3)]),
                  ),
                ],

                if (widget.game.numPlayers == 5) ...[
                  // Top row: Players 2 and 3
                  Expanded(
                    child: Row(children: [playerSection(1), playerSection(2)]),
                  ),

                  // Middle row: Players 1 and 4
                  Expanded(
                    child: Row(children: [playerSection(0), playerSection(3)]),
                  ),

                  // Bottom row: Player 5
                  playerSection(4),
                ],

                if (widget.game.numPlayers == 6) ...[
                  Expanded(
                    child: Row(
                      children: [
                        playerSection(0),
                        playerSection(1),
                        playerSection(2),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        playerSection(3),
                        playerSection(4),
                        playerSection(5),
                      ],
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
