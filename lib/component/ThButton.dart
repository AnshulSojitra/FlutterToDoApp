import 'package:flutter/material.dart';
class ThButton extends StatelessWidget {
  final String text;
  final String variant;
  final Icon? icon;
  const ThButton({super.key, this.text='ok', this.variant='default',this.icon});

  @override
  Widget build(BuildContext context) {
    var backgroundColor=Colors.transparent;
    var foregroundColor=Colors.black;
    var border=BorderSide(color: Colors.grey, width: 1);
    var hoverBackground;
    var hoverForeground;
    var hoverborder;
    if(variant=='primary'){
      backgroundColor = Colors.deepPurpleAccent;
      foregroundColor=Colors.white;
      border=BorderSide(color: Colors.deepPurpleAccent, width: 1);
      hoverborder=BorderSide(color: Colors.deepPurpleAccent.shade400, width: 1);
      hoverForeground=Colors.white;
      hoverBackground=Colors.deepPurpleAccent.shade400;
    }

    else if(variant=='primary-outline'){
      backgroundColor = Colors.transparent;
      foregroundColor=Colors.deepPurpleAccent;
      border=BorderSide(color: Colors.deepPurpleAccent, width: 1);
      hoverborder=BorderSide(color: Colors.deepPurpleAccent, width: 1);
      hoverBackground=Colors.deepPurpleAccent;
      hoverForeground=Colors.white;
    }
    else if(variant=='dark'){
      backgroundColor = Colors.black;
      foregroundColor=Colors.white;
      border=BorderSide(color: Colors.black, width: 1);
      hoverborder=BorderSide(color: Colors.black12, width: 1);
      hoverBackground=Colors.black87;
      hoverForeground=Colors.white;
    }
    else if(variant=='dark-outline'){
      backgroundColor = Colors.transparent;
      foregroundColor=Colors.black;
      border=BorderSide(color: Colors.black, width: 1);
      hoverborder=BorderSide(color: Colors.black, width: 1);
      hoverBackground=Colors.black;
      hoverForeground=Colors.white;
    }
    else if(variant=='plain'){
      return TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          foregroundColor: Colors.black, // Text + icon color
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.black; // Hover background color
              }
              return null;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.white; // Hover: white text
            }
            return Colors.black;    // Default: blue text
          }),
          animationDuration: Duration.zero
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ?icon,
            const SizedBox(width: 6),
            Text(text,style: TextStyle(fontSize: 18,fontFamily: 'RobotoFont'),),
          ],
        ),
      );
    }
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        elevation: 0, // No shadow
        backgroundColor:backgroundColor,
        foregroundColor: foregroundColor,
        side: border,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
      ).copyWith(
          animationDuration: Duration.zero,
        side: WidgetStateProperty.resolveWith<BorderSide>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return hoverborder;// on hover
            }
            return border;   // default
          },
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {

          if (states.contains(WidgetState.hovered)) {
            return hoverBackground;// Hover: blue background

          }
          return backgroundColor;   // Default: white background
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return hoverForeground; // Hover: white text
          }
          return foregroundColor;    // Default: blue text
        }),
        elevation: WidgetStateProperty.resolveWith((states){
          if(states.contains(WidgetState.hovered)){
            return 0;
          }
          return 0;
        }

        ),
      ),
      child: Text(text),
    );
  }
}


