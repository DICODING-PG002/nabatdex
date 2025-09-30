import 'package:flutter/material.dart';

class DialogContent extends StatelessWidget {
  final List<Widget> dialogContentChildren;

  const DialogContent({super.key, required this.dialogContentChildren});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: dialogContentChildren,
      ),
    );
  }
}
