import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Color backgroundColor;
  final Color iconColor;
  final IconData? iconData;
  final bool outline;
  final bool icon;
  final bool alt;
  final bool dialog;
  final double minSize;

  const CustomButton({
    Key? key,
    required this.onTap,
    required this.label,
    this.minSize = 48,
    this.iconData,
    this.backgroundColor = Palette.primary,
    this.iconColor = Colors.white,
  })  : outline = false,
        icon = false,
        alt = false,
        dialog = false,
        super(key: key);

  const CustomButton.outline({
    Key? key,
    required this.onTap,
    required this.label,
    this.minSize = 48,
    this.iconData,
    this.backgroundColor = Palette.primary,
    this.iconColor = Colors.white,
  })  : outline = true,
        icon = false,
        alt = false,
        dialog = false,
        super(key: key);

  const CustomButton.alt({
    Key? key,
    required this.onTap,
    required this.label,
    this.minSize = 52,
    this.iconData,
    this.backgroundColor = Palette.primary,
    this.iconColor = Colors.white,
  })  : outline = false,
        icon = false,
        alt = true,
        dialog = false,
        super(key: key);

  const CustomButton.icon({
    Key? key,
    required this.onTap,
    required this.label,
    required this.iconData,
    this.minSize = 52,
    this.backgroundColor = Palette.primary,
    this.iconColor = Colors.white,
  })  : outline = false,
        icon = true,
        alt = false,
        dialog = false,
        super(key: key);

  const CustomButton.dialog({
    Key? key,
    required this.onTap,
    required this.label,
    this.iconData,
    this.minSize = 52,
    this.backgroundColor = Palette.primary,
    this.iconColor = Colors.white,
  })  : outline = false,
        icon = false,
        alt = false,
        dialog = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (dialog) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            color: Palette.primary,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }
    if (alt) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            color: Palette.culture,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 10.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconData != null)
                Icon(
                  iconData,
                  size: 18.0,
                  color: Palette.primary,
                ),
              if (iconData != null) gap12,
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Palette.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (icon) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: backgroundColor,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconData != null)
                Flexible(
                  flex: 20,
                  child: Icon(
                    iconData,
                    size: 18.0,
                    color: iconColor,
                  ),
                ),
              if (iconData != null) gap12,
              Flexible(
                flex: 80,
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Palette.gray1,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (outline) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          constraints: BoxConstraints(minHeight: minSize),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: Palette.primary.withOpacity(.15),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: Text(
            label,
            style: const TextStyle(
              color: Palette.primary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      // behavior: HitTestBehavior.opaque,
      child: Align(
        // widthFactor: 1.0,
        heightFactor: 1.0,
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 44.0,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            // mainAxisSize:
            //     iconData == null ? MainAxisSize.max : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (iconData != null)
                Flexible(
                  flex: 20,
                  child: Icon(
                    iconData,
                    size: 18.0,
                    color: iconColor,
                  ),
                ),
              if (iconData != null) gap12,
              Flexible(
                flex: 80,
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          // onPressed: onTap,
        ),
      ),
    );
  }
}
