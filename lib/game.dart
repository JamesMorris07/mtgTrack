import 'package:flutter/material.dart';
import 'ui/ui.dart';
class Game{
    int numPlayers;
    int startingLife;

    Game({
        this.numPlayers = 4,
        this.startingLife = 40,
    });
}