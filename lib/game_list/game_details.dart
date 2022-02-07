import 'package:flemu/constants.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import '../api/file_manager.dart';
import 'game_details.i18n.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

class GameDetails extends StatefulWidget {
  final ListFile game;
  final GameSystem system;

  const GameDetails({Key? key, required this.system, required this.game})
      : super(key: key);

  @override
  State<GameDetails> createState() =>
      // ignore: no_logic_in_create_state
      _GameDetailsState(game: game, system: system);
}

class _GameDetailsState extends State<GameDetails> {
  final ListFile game;
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
      description =
          await FileManager.fetchGameDescription(system.id, game.name);
    } catch (e) {
      description = [
        GameDescription(lang: "", description: "Error loading description".i18n)
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
    return Column(children: [
      Expanded(
          child: Padding(
              padding: const EdgeInsets.all(30),
              child: Image.network(buildImageUrl(system.id, game.name),
                  fit: BoxFit.fitWidth,
                  loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;

                return Center(child: Text('Loading image...'.i18n));
              }))),
      const SizedBox(height: defaultPadding),
      Text(game.name, style: const TextStyle(fontSize: 30)),
      const SizedBox(height: defaultPadding),
      SizedBox(
          height: descriptionHeight,
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: _loadingDescription
                ? Text("Loading description...".i18n)
                : (Text(_description.isEmpty
                    ? "No description available".i18n
                    : _description.firstWhere((x) => x.lang == I18n.language,
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
                        if (game.url != "") {
                          js.context.callMethod("open", [game.url]);
                        } else {
                          js.context.callMethod('open', [
                            buildFileHandlerUrl(
                                system.handler, game.name, system.bios)
                          ]);
                        }
                      },
                      child: Text("PLAY".i18n)))),
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
                            'open', [buildDownloadUrl(system.id, game.name)]);
                      },
                      child: const Icon(Icons.download)))),
        ],
      ),
    ]);
  }
}
