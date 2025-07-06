import 'package:flutter/material.dart';
import 'package:untitled1/pages/NoteStore.dart';
class ThFooter extends StatelessWidget implements PreferredSizeWidget {

  final List<Widget> rightWidgets;
  final List<Widget> leftWidgets;
  const ThFooter({super.key,this.rightWidgets=const [],this.leftWidgets=const [],});
  List<Widget> spaced(List<Widget> widgets, {double space = 16}) {
    return [
      for (int i = 0; i < widgets.length; i++) ...[
        if (i != 0) SizedBox(width: space),
        widgets[i],
      ]
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NoteStore.isDarkMode?Colors.grey.shade900:Colors.white,
        boxShadow: [
          BoxShadow(
            color: NoteStore.isDarkMode?Colors.white:Colors.black,
            blurRadius: 0,
            offset: const Offset(0, -0.15),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              SizedBox(width: 16,),
              ...spaced(leftWidgets),
              Spacer(),
              ...spaced(rightWidgets),
              SizedBox(width: 16,),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}