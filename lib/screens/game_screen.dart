import 'package:flutter/material.dart';
import '../game.dart';
import '../models/damage_event.dart';
import '../models/debug.dart';
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
  changeDamage(int amount) {
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