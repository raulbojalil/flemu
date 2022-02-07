import 'package:flemu/common/error_message.dart';
import 'package:flemu/common/skeleton_loader.dart';
import 'package:flemu/constants.dart';
import 'package:flutter/material.dart';
import 'game_list.i18n.dart';
import '../api/file_manager.dart';

import 'dart:js' as js;

class GameList extends StatefulWidget {
  final Function onGameSelected;
  final GameSystem system;

  const GameList({required this.system, required this.onGameSelected});

  @override
  State<GameList> createState() =>
      // ignore: no_logic_in_create_state
      _GameListState(system: system, onGameSelected: onGameSelected);
}

class _GameListState extends State<GameList> {
  final Function onGameSelected;
  final GameSystem system;

  _GameListState({required this.system, required this.onGameSelected});

  bool _loading = false;
  bool _hasError = false;
  List<ListFile> _games = [];
  String _filterText = "";

  Future<void> loadGames() async {
    setState(() {
      _loading = true;
    });

    try {
      var games = await FileManager.listGames(system.id);
      setState(() {
        _games = games;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadGames();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const SkeletonLoader()
        : _hasError
            ? const ErrorMessage()
            : Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                    padding: const EdgeInsets.all(searchBoxPadding),
                    child: TextField(
                      onChanged: (text) {
                        setState(() {
                          _filterText = text;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        labelText: "Search".i18n,
                        prefixIcon: const Icon(Icons.search),
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      ),
                    )),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(defaultPadding, 0,
                            defaultPadding, defaultPadding * 2),
                        child: ListView(
                          children: [
                            for (var game in _games.where((element) =>
                                _filterText == "" ||
                                element.name
                                    .toLowerCase()
                                    .contains(_filterText.toLowerCase())))
                              ListTile(
                                title: Text(game.name),
                                onTap: () {
                                  onGameSelected(game);
                                },
                              ),
                          ],
                        )))
              ]);
  }
}
