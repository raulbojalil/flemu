import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonTheme(
        shimmerGradient: const LinearGradient(
          colors: [
            Color(0xFFAAAAAA),
            Color(0xFFCCCCCC),
            Color(0xFFAAAAAA),
          ],
          stops: [
            0.1,
            0.5,
            0.9,
          ],
        ),
        themeMode: ThemeMode.light,
        child: SkeletonListView(
            item: SkeletonListTile(
          hasLeading: false,
          padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
          hasSubtitle: false,
          titleStyle: SkeletonLineStyle(
              randomLength: false, borderRadius: BorderRadius.circular(12)),
        )));
  }
}
