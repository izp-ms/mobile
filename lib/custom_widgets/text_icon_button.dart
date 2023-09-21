import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextIconButton extends StatelessWidget {
  final String text;
  final bool shouldHaveIcon;
  final IconData? iconData;
  final IconSide iconSide;
  final VoidCallback? onTap;
  final double fontSize;
  final double iconSize;
  final MainAxisAlignment mainAxisAlignment;
  final Color color;  // New argument

  TextIconButton({
    required this.text,
    this.shouldHaveIcon = false,
    this.iconData,
    this.iconSide = IconSide.left,
    this.onTap,
    this.fontSize = 10.0,
    this.iconSize = 15.0,
    this.mainAxisAlignment = MainAxisAlignment.end,
    this.color = Colors.black,  // Default value
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    if (shouldHaveIcon && iconData != null) {
      final iconWidget = Icon(
        iconData,
        size: iconSize,
        color: color,  // Apply color to icon
      );
      children.add(iconWidget);
      children.add(const SizedBox(width: 3));
    }

    children.add(
      Text(
        text,
        style: GoogleFonts.rubik(
          fontSize: fontSize,
          color: color,  // Apply color to text
        ),
      ),
    );

    if (iconSide == IconSide.right && shouldHaveIcon && iconData != null) {
      children = children.reversed.toList();
    }

    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: children,
        ),
      ),
    );
  }
}

enum IconSide {
  left,
  right,
}