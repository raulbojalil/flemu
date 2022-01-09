import 'package:flemu/common/error_message.dart';
import 'package:flemu/common/skeleton_loader.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import '../api/file_manager.dart';

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

  bool _isLoading = true;
  bool _hasError = false;
  List<GameSystem> _systems = [];

  Future<void> loadSystems() async {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });

    try {
      var systems = await FileManager.listSystems();

      setState(() {
        _systems = systems;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadSystems();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const SkeletonLoader()
        : _hasError
            ? const ErrorMessage()
            : ListView(children: [
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
