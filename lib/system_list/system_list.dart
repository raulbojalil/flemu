import 'package:flemu/constants.dart';
import 'package:flemu/responsive_container.dart';
import 'package:flutter/material.dart';

import '../api/file_manager.dart';
import 'dart:js' as js;

class SystemList extends StatefulWidget {
  final Function onSystemSelected;

  const SystemList({required this.onSystemSelected});

  @override
  State<SystemList> createState() =>
      // ignore: no_logic_in_create_state
      _SystemListState(onSystemSelected: onSystemSelected);
}

class _SystemListState extends State<SystemList> {
  final Function onSystemSelected;

  _SystemListState({required this.onSystemSelected});

  List<GameSystem> _systems = [];

  Future<void> loadSystems() async {
    var systems = await FileManager.listSystems();

    setState(() {
      _systems = systems;
    });
  }

  @override
  void initState() {
    super.initState();
    loadSystems();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      for (var system in _systems)
        ListTile(
          title: Text(system.name),
          onTap: () {
            onSystemSelected(system);
          },
        ),
    ]);
  }
}
