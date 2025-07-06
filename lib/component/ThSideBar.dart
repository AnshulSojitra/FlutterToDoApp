import 'package:flutter/material.dart';
import 'package:untitled1/component/ThButton.dart';
import 'package:untitled1/pages/NoteStore.dart';

class ThSideBar extends StatelessWidget {
  final List<ThButton> upperbuttons;
  final List<ThButton> lowerbuttons;
  final Color? color;
  final double width;
  const ThSideBar({super.key, this.upperbuttons = const [],this.lowerbuttons=const[], this.color,this.width=240});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: color ?? (NoteStore.isDarkMode ? Colors.black87 : Colors.white70),
        boxShadow: [
          BoxShadow(
            //color: Colors.white38,
            color: NoteStore.isDarkMode?Colors.white:Colors.black,
            offset: const Offset(0.15, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20,bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Expanded(
              child: ListView(
                children: upperbuttons,
              ),
            ),


            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: Divider(color: Colors.grey.withAlpha((0.5*255).toInt()),thickness: 1,)),
            ...lowerbuttons,
                ])
          ]
        ),
      ),
    );
  }
}
