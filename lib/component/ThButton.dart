import 'package:flutter/material.dart';
class ThButton extends StatefulWidget {
  final String text;
  final String variant;
  final Icon? icon;
  final bool onpage;
  final VoidCallback? onPress;
  const ThButton({super.key, this.text='ok', this.variant='default',this.icon,this.onpage=false, this.onPress});

  @override
  State<ThButton> createState() => _ThButtonState();
}

class _ThButtonState extends State<ThButton> {
  @override
  Widget build(BuildContext context) {
    var backgroundColor=Colors.transparent;
    var foregroundColor=Colors.black;
    var border=BorderSide(color: Colors.grey, width: 1);
    Color hoverBackground=Colors.transparent;
    Color hoverForeground=Colors.transparent;
    BorderSide hoverborder=BorderSide(color: Colors.transparent, width: 1);
    if(widget.variant=='primary'){
      backgroundColor = Colors.deepPurpleAccent;
      foregroundColor=Colors.white;
      border=BorderSide(color: Colors.deepPurpleAccent, width: 1);
      hoverborder=BorderSide(color: Colors.deepPurpleAccent.shade400, width: 1);
      hoverForeground=Colors.white;
      hoverBackground=Colors.deepPurpleAccent.shade400;
    }

    else if(widget.variant=='primary-outline'){
      backgroundColor = Colors.transparent;
      foregroundColor=Colors.deepPurpleAccent;
      border=BorderSide(color: Colors.deepPurpleAccent, width: 1);
      hoverborder=BorderSide(color: Colors.deepPurpleAccent, width: 1);
      hoverBackground=Colors.deepPurpleAccent;
      hoverForeground=Colors.white;
    }
    else if(widget.variant=='dark'){
      backgroundColor = Colors.black;
      foregroundColor=Colors.white;
      border=BorderSide(color: Colors.black, width: 1);
      hoverborder=BorderSide(color: Colors.black12, width: 1);
      hoverBackground=Colors.black87;
      hoverForeground=Colors.white;
    }
    else if(widget.variant=='dark-outline'){
      backgroundColor = Colors.transparent;
      foregroundColor=Colors.black;
      border=BorderSide(color: Colors.black, width: 1);
      hoverborder=BorderSide(color: Colors.black, width: 1);
      hoverBackground=Colors.black;
      hoverForeground=Colors.white;
    }
    else if(widget.variant=='plain'){
      return TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft:Radius.zero,bottomLeft:Radius.zero,topRight: Radius.circular(30),bottomRight: Radius.circular(30))
          ),
          foregroundColor:Colors.black, // Text + icon color
          padding:  EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width<=426?1: 12, vertical:MediaQuery.of(context).size.width<=426?1: 8),
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                (states) {
              if (states.contains(WidgetState.hovered)) {
                return Colors.black; // Hover background color
              }
              return widget.onpage? Colors.deepPurpleAccent:Colors.transparent;
            },
          ),
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.black12; // Hover background color
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
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width<=426?0:10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ?widget.icon,
              const SizedBox(width: 19),
              Text(widget.text,style: TextStyle(fontSize: 18,fontFamily: 'RobotoFont'),),
            ],
          ),
        ),
      );
    }
    return ElevatedButton(
      onPressed: widget.onPress,
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
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.transparent; // Hover background color
            }
            return Colors.transparent;
          },
        ),
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
      child: Text(widget.text),
    );
  }
}


