import 'package:flemu/constants.dart';
import 'package:flemu/responsive_container.dart';
import 'package:flutter/material.dart';

import '../api/file_manager.dart';
import 'dart:js' as js;

import '../app_config.dart';

class GameDetails extends StatefulWidget {
  final String game;
  final GameSystem system;

  GameDetails({Key? key, required this.system, required this.game})
      : super(key: key);

  @override
  State<GameDetails> createState() =>
      _GameDetailsState(game: game, system: system);
}

class _GameDetailsState extends State<GameDetails> {
  final String game;
  final GameSystem system;

  bool _loadingDescription = false;
  List<GameDescription> _description = [];

  _GameDetailsState({required this.game, required this.system});

  void loadDescription() async {
    setState(() {
      _loadingDescription = true;
    });

    List<GameDescription> description = [];
    try {
      description = await FileManager.fetchGameDescription(system.id, game);
    } catch (e) {
      description = [
        GameDescription(lang: "en", description: "Error loading description")
      ];
      print(e);
    }
    setState(() {
      _description = description;
      _loadingDescription = false;
    });
  }

  @override
  void initState() {
    loadDescription();
  }

  @override
  Widget build(BuildContext context) {
    return game == null || game == ""
        ? const Center(child: Text("Select a game"))
        : Column(children: [
            Expanded(
                child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Image.network(buildImageUrl(system.id, game),
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
                  child: _loadingDescription
                      ? const Text("Loading description...")
                      : (Text(_description.isEmpty
                          ? "No description"
                          : _description.firstWhere((x) => x.lang == 'en',
                              orElse: () {
                              return _description[0];
                            }).description)),
                )),
            const SizedBox(height: defaultPadding),
            Row(
              children: [
                Expanded(
                    child: SizedBox(
                        height: 80,
                        child: ElevatedButton(
                            style: TextButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 30),
                                padding: const EdgeInsets.all(30)),
                            onPressed: () {
                              js.context.callMethod('open', [
                                buildFileHandlerUrl(
                                    system.handler, game, system.bios)
                              ]);
                            },
                            child: const Text("PLAY")))),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                        height: 80,
                        child: ElevatedButton(
                            style: TextButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 20),
                                padding: const EdgeInsets.all(20)),
                            onPressed: () {
                              js.context.callMethod(
                                  'open', [buildDownloadUrl(system.id, game)]);
                            },
                            child: const Icon(Icons.download)))),
              ],
            ),
          ]);
  }
}
