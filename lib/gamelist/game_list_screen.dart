import 'package:flemu/constants.dart';
import 'package:flemu/responsive_container.dart';
import 'package:flutter/material.dart';

import '../api/file_manager.dart';
import 'dart:js' as js;

import 'game_details.dart';
import 'game_list.dart';

class GameListScreen extends StatefulWidget {
  final String system;
  const GameListScreen({Key? key, required this.system}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<GameListScreen> createState() => _GameListScreenState(system: system);
}

class _GameListScreenState extends State<GameListScreen> {
  String _selectedGame = "";
  final String system;

  _GameListScreenState({required this.system});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(system.toUpperCase()),
      ),
      body: ResponsiveContainer(
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 4,
                  child: GameList(
                      system: system,
                      onGameSelected: (game) {
                        setState(() {
                          _selectedGame = game;
                        });
                      })),
              Expanded(
                  flex: 2,
                  child: Container(
                      color: secondaryBgColor,
                      padding: const EdgeInsets.all(defaultPadding),
                      child: GameDetails(
                        key: Key(_selectedGame),
                        game: _selectedGame,
                        system: system,
                      )))
            ],
          ),
          mobile: GameList(
              system: system,
              onGameSelected: (String game) {
                var emulatorUrl = "$backendUrl/?core=$system&filename=$game";
                js.context.callMethod('open', [emulatorUrl]);
              })), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
