import 'package:flutter/material.dart';
import 'ui/ui.dart';

class Game{
    int numPlayers;
    int startingLife;

    Game({
        this.numPlayers = 4, // default 4 players
        this.startingLife = 40,
    });
}