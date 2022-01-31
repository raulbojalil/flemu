import 'package:flemu/common/error_message.dart';
import 'package:flemu/common/skeleton_loader.dart';
import 'package:flemu/constants.dart';
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
            : Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                    itemCount: _systems.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Container(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: const EdgeInsets.all(defaultPadding / 2),
                            child: InkWell(
                                onTap: () {
                                  onSystemSelected(_systems[index]);
                                },
                                child: Image.network(
                                    buildSystemImageUrl(_systems[index].id)))),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(15)),
                      );
                    }));
  }
}
