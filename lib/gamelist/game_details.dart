import 'package:flemu/constants.dart';
import 'package:flemu/responsive_container.dart';
import 'package:flutter/material.dart';

import '../api/file_manager.dart';
import 'dart:js' as js;

class GameDetails extends StatefulWidget {
  final String game;
  final String system;

  GameDetails({Key? key, required this.system, required this.game})
      : super(key: key);

  @override
  State<GameDetails> createState() =>
      _GameDetailsState(game: game, system: system);
}

class _GameDetailsState extends State<GameDetails> {
  final String game;
  final String system;

  _GameDetailsState({required this.game, required this.system});

  @override
  Widget build(BuildContext context) {
    return game == null || game == ""
        ? Center(child: Text("Select a game"))
        : Column(children: [
            Expanded(
                child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Image.network(
                        "$backendUrl/filemanager/image?system=$system&name=$game",
                        fit: BoxFit.fitWidth,
                        loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;

                      return const Center(child: Text('Loading image...'));
                    }))),
            const SizedBox(height: defaultPadding),
            Text(game, style: const TextStyle(fontSize: 30)),
            const SizedBox(height: defaultPadding),
            SizedBox(
                height: 100,
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Text(
                      "This is a placeholder for the description of the game. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                )),
            const SizedBox(height: defaultPadding),
            SizedBox(
                height: 100,
                child: ElevatedButton(
                    style: TextButton.styleFrom(
                        textStyle: TextStyle(fontSize: 30),
                        padding: EdgeInsets.all(30)),
                    onPressed: () {
                      var emulatorUrl =
                          "$backendUrl/?core=$system&filename=$game";
                      js.context.callMethod('open', [emulatorUrl]);
                    },
                    child: const Text("PLAY"))),
          ]);
  }
}
