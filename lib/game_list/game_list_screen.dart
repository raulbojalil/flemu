import 'package:flemu/constants.dart';
import 'package:flemu/responsive_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'game_list_screen.i18n.dart';

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
  ListFile? _selectedGame;
  final GameSystem system;

  _GameListScreenState({required this.system});

  double downloadProgress = 0;
  String downloadStatus = '';
  bool _loadingCovers = false;

  Future<void> loadAllCovers(setState) async {
    _loadingCovers = true;
    setState(() {
      downloadStatus = 'Initializing...'.i18n;
      downloadProgress = 0;
    });

    try {
      final games = await FileManager.listGames(system.id);
      var index = 0;
      for (final game in games) {
        final progress = index * 100 / games.length;
        await FileManager.fetchGameDescription(system.id, game.name);
        await FileManager.fetchGameImage(system.id, game.name);
        setState(() {
          downloadProgress = progress / 100;
          downloadStatus = '${game.name} (${progress.toStringAsFixed(0)}%)';
        });
        index++;
      }
      setState(() {
        downloadProgress = 1;
        downloadStatus = 'The process has completed successfully.'.i18n;
      });
    } catch (e) {
      setState(() {
        downloadProgress = 1;
        downloadStatus = 'An error has occurred, please try again later.'.i18n;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(system.name), actions: [
        IconButton(
            tooltip: "Download all images and descriptions".i18n,
            icon: const Icon(Icons.cloud_download),
            onPressed: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (dialogContext, setState) {
                      if (!_loadingCovers) loadAllCovers(setState);
                      return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 2.0,
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              width: 600,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(downloadStatus),
                                  const SizedBox(height: defaultPadding),
                                  downloadProgress < 1
                                      ? LinearProgressIndicator(
                                          value: downloadProgress,
                                          minHeight: 20,
                                        )
                                      : ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(dialogContext);
                                          },
                                          child: Text("Close".i18n))
                                ],
                              )));
                    });
                  });
            }),
      ]),
      body: ResponsiveContainer(
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 4,
                  child: GameList(
                      system: system,
                      onGameSelected: (ListFile game) {
                        setState(() {
                          _selectedGame = game;
                        });
                      })),
              Expanded(
                  flex: 2,
                  child: Container(
                      color: secondaryBgColor,
                      padding: const EdgeInsets.all(defaultPadding),
                      child: _selectedGame != null
                          ? GameDetails(
                              key: Key(_selectedGame?.name ?? ""),
                              game: _selectedGame as ListFile,
                              system: system,
                            )
                          : Center(
                              child: Text("Select an item in the list".i18n))))
            ],
          ),
          mobile: GameList(
              system: system,
              onGameSelected: (ListFile game) {
                if (game.url != "") {
                  js.context.callMethod('open', [game.url]);
                } else {
                  js.context.callMethod('open', [
                    buildFileHandlerUrl(system.handler, game.name, system.bios)
                  ]);
                }
              })), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
