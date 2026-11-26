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


  //current life totals stored as a list (player 1 = 0)
  late List<int> playerLifeTotals;

  //history of  damage events throughout the game
  final List<DamageEvent> damageHistory = [];
  //tracks ongoing damage interaction
  int? pendingAttacker;
  int? pendingRecipient;
  int pendingDamage = 0;

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
    testDebug(playerLifeTotals);
  }
  void beginDamage(int attacker, int recipient){
    setState(() {
      pendingAttacker = attacker;
      pendingRecipient = recipient;
      pendingDamage = 0;
    });
  }
   void changeDamage(int amount) {
    setState((){
      pendingDamage = (pendingDamage + amount).clamp(0,999).toInt();
    });
  }
  void confirmDamage() {
    if (pendingAttacker == null || pendingRecipient == null || pendingDamage <=0){
      return; //no damage dealt nothing to log
    }
    setState((){
      //subtract the damage
      playerLifeTotals[pendingRecipient!] -= pendingDamage;
      //record the event
      damageHistory.add(DamageEvent(
      attacker: pendingAttacker!,
      recipient: pendingRecipient!,
      amount: pendingDamage,
      ),
    );
    //reset for next event
    pendingAttacker = null;
    pendingRecipient = null;
    pendingDamage = 0;
    });
  }
  void cancelDamage(){
    setState((){
      pendingAttacker = null;
      pendingRecipient = null;
      pendingDamage = 0;
    });
  }
  void changeLife(int player, int amount) {
    setState(() {
      playerLifeTotals[player] += amount;
    });
  }
  Widget damageSection(int index) {
  return Expanded(
    child: Container(
      color: playerColors[index % playerColors.length],
      child: DamagePanel(
        damage: pendingDamage,
        onIncrease: () => changeDamage(1),
        onDecrease: () => changeDamage(-1),
        onConfirm: confirmDamage,
        onCancel: cancelDamage,
      ),
    ),
  );
}
  Widget playerSection(int index) {
  if (pendingRecipient == index) {
    return damageSection(index);
  }

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
      color: playerColors[index % playerColors.length].withValues(alpha: 0.4),
      child: const Center(
        child: Text('Attacking...'),
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
                    playerSection(4)
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