import 'package:flemu/constants.dart';
import 'package:flemu/responsive_container.dart';
import 'package:flutter/material.dart';

import '../api/file_manager.dart';
import 'dart:js' as js;

import '../app_config.dart';
import 'game_details.dart';
import 'game_list.dart';

class GameListScreen extends StatefulWidget {
  final GameSystem system;
  const GameListScreen({Key? key, required this.system}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<GameListScreen> createState() => _GameListScreenState(system: system);
}

class _GameListScreenState extends State<GameListScreen> {
  String _selectedGame = "";
  final GameSystem system;

  _GameListScreenState({required this.system});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(system.name), actions: [
        IconButton(
          icon: const Icon(Icons.fullscreen),
          onPressed: () {
            js.context.callMethod('toggleFullscreen');
          },
        ),
      ]),
      body: ResponsiveContainer(
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 4,
                  child: GameList(
                      system: system.core,
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
                        system: system.core,
                      )))
            ],
          ),
          mobile: GameList(
              system: system.core,
              onGameSelected: (String game) {
                js.context.callMethod(
                    'open', [buildFileHandlerUrl(system.core, game)]);
              })), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
