import 'package:flemu/game_list/game_list_screen.dart';
import 'package:flemu/system_list/system_list.dart';
import 'package:flutter/material.dart';

import '../api/file_manager.dart';
import 'dart:js' as js;

class SystemListScreen extends StatefulWidget {
  const SystemListScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<SystemListScreen> createState() => _SystemListScreenState();
}

class _SystemListScreenState extends State<SystemListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a system'), actions: [
        IconButton(
          icon: const Icon(Icons.fullscreen),
          onPressed: () {
            js.context.callMethod('toggleFullscreen');
          },
        ),
      ]),
      body: SystemList(onSystemSelected: (GameSystem system) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GameListScreen(system: system)),
        );
      }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
