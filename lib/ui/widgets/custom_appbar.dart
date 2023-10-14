import 'package:flutter/material.dart';

import '../../config/config.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color textColor;
  final bool implyLeading;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomAppbar(
      {super.key,
      this.title,
      this.textColor = Palette.primary,
      this.implyLeading = false,
      this.centerTitle = true,
      this.leading,
      this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: leading,
      title: title != null
          ? Text(title!,
              style: TextStyle(
                  fontSize: Sizes.s16,
                  color: textColor,
                  fontWeight: FontWeight.bold))
          : null,
      centerTitle: centerTitle,
      actions: actions,
      automaticallyImplyLeading: implyLeading,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, Sizes.s60);
}
