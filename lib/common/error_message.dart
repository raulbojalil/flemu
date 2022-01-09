import 'package:flemu/constants.dart';
import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: errorColor,
        width: double.infinity,
        padding: const EdgeInsets.all(defaultPadding),
        child: const Text(
            "An error has occurred. Please check your connection and try again."));
  }
}
