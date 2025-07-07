import 'package:flutter/material.dart';
import 'package:untitled1/pages/NoteStore.dart';

class ThButton extends StatefulWidget {
  final String text;
  final String variant;
  final Icon? icon;
  final bool onpage;
  final VoidCallback? onPress;
  final double? width;
  final double? height;
  const ThButton({
    super.key,
    this.text = 'ok',
    this.variant = 'default',
    this.icon,
    this.onpage = false,
    this.onPress,
    this.width,
    this.height,
  });

  @override
  State<ThButton> createState() => _ThButtonState();
}

class _ThButtonState extends State<ThButton> {
  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width <= 426;

    // Default styles
    Color backgroundColor = Colors.transparent;
    Color foregroundColor = Colors.black;
    BorderSide border = const BorderSide(color: Colors.grey, width: 1);
    Color hoverBackground = Colors.transparent;
    Color hoverForeground = Colors.black;
    Color darkhoverForeground= Colors.white;
    BorderSide hoverBorder = const BorderSide(color: Colors.transparent, width: 1);

    // Apply variant styles
    switch (widget.variant) {
      case 'primary':
        backgroundColor = Colors.deepPurpleAccent;
        foregroundColor = Colors.white;
        border = BorderSide(color: Colors.deepPurpleAccent);
        hoverForeground=Colors.white;
        hoverBorder = BorderSide(color: Colors.deepPurpleAccent.shade400);
        hoverBackground = Colors.deepPurpleAccent.shade400;
        break;

      case 'primary-outline':
        foregroundColor = Colors.deepPurpleAccent;
        border = BorderSide(color: Colors.deepPurpleAccent);
        hoverBorder = BorderSide(color: Colors.deepPurpleAccent);
        hoverBackground = Colors.deepPurpleAccent;
        hoverForeground = Colors.white;
        break;

      case 'dark':
        backgroundColor = Colors.black;
        foregroundColor = Colors.white;
        border = const BorderSide(color: Colors.black);
        hoverBorder = const BorderSide(color: Colors.black12);
        hoverBackground = Colors.black87;
        break;

      case 'dark-outline':
        border = BorderSide(color: Colors.black);
        hoverBorder = BorderSide(color: Colors.black);
        hoverBackground = Colors.black;
        hoverForeground = Colors.white;
        break;
    }

    // Handle plain variant separately
    if (widget.variant == 'plain') {
      return SizedBox(
        width: widget.width,
        child: TextButton(
          onPressed: widget.onPress,
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.zero,
                bottomLeft: Radius.zero,
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 1 : 12,
              vertical: isMobile ? 1 : 8,
            ),
          ).copyWith(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.hovered)) {
                return NoteStore.isDarkMode?Colors.white:Colors.black;
              }
              return widget.onpage ? Colors.deepPurpleAccent : Colors.transparent;
            }),
            overlayColor: MaterialStateProperty.all(Colors.black12),
            foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.hovered)) {
                return NoteStore.isDarkMode ? Colors.black : Colors.white;
              }
              return NoteStore.isDarkMode ? Colors.white : Colors.black;
            }),
            animationDuration: Duration.zero,
          ),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 0 : 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (widget.icon != null)
                  Icon(
                    widget.icon!.icon,
                    size: widget.icon!.size,
                  ),
                if (widget.icon != null) const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.text,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'RobotoFont',
                    ),
                  ),
                )],
            ),
          ),
        ),
      );
    }

    // Default button variant
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
        onPressed: widget.onPress,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          side: border,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ).copyWith(
          animationDuration: Duration.zero,
          side: MaterialStateProperty.resolveWith<BorderSide>(
                (states) => states.contains(MaterialState.hovered) ? hoverBorder : border,
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) => states.contains(MaterialState.hovered) ? hoverBackground : backgroundColor,
          ),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) => states.contains(MaterialState.hovered)
                ? hoverForeground
                : foregroundColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null)
              Icon(
                widget.icon!.icon,
                size: widget.icon!.size,
              ),
            if (widget.icon != null) const SizedBox(width: 8),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'RobotoFont',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
