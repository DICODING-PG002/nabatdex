import 'package:flutter/material.dart';
import 'package:nabatdex/core/constant/app_theme.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color titleColor;
  final bool isCenterTitle;
  final Widget leading;
  final TextStyle? textStyle;

  const MainAppBar({
    super.key,
    required this.title,
    this.titleColor = AppTheme.textColor,
    this.isCenterTitle = true,
    this.leading = const BackButton(),
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: Text(
        title,
        style:
            textStyle ??
            TextTheme.of(context).titleMedium?.copyWith(color: titleColor),
      ),
      centerTitle: isCenterTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
