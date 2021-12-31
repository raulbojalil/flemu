import 'package:flemu/constants.dart';
import 'package:flemu/responsive_container.dart';
import 'package:flutter/material.dart';

import '../api/file_manager.dart';
import 'dart:js' as js;

class GameList extends StatefulWidget {
  final Function onGameSelected;

  const GameList({required this.onGameSelected});

  @override
  State<GameList> createState() =>
      // ignore: no_logic_in_create_state
      _GameListState(onGameSelected: onGameSelected);
}

class _GameListState extends State<GameList> {
  final Function onGameSelected;

  _GameListState({required this.onGameSelected});

  List<String> _games = [];

  Future<void> loadGames() async {
    var games = await FileManager.listGames('snes');

    setState(() {
      _games = games;
    });
  }

  @override
  void initState() {
    super.initState();
    loadGames();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.all(searchBoxPadding),
          child: TextField(
            onChanged: (text) {
              //TODO: Implement the search
            },
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
              labelText: "Search",
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            ),
          )),
      Expanded(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  defaultPadding, 0, defaultPadding, defaultPadding * 2),
              child: ListView(
                children: [
                  for (var game in _games)
                    ListTile(
                      title: Text(game),
                      onTap: () {
                        onGameSelected(game);
                      },
                    ),
                ],
              )))
    ]);
  }
}
