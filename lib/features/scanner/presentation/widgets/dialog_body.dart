import 'package:flutter/material.dart';
import 'package:nabatdex/features/scanner/presentation/widgets/dialog_content.dart';

class DialogBody extends StatelessWidget {
  final DialogContent dialogContent;

  const DialogBody({super.key, required this.dialogContent});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0),
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Theme.of(context).dialogTheme.backgroundColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: dialogContent,
      ),
    );
  }
}
