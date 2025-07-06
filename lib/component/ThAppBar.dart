import 'package:flutter/material.dart';
import 'package:untitled1/pages/NoteStore.dart';



class ThAppBar extends StatelessWidget implements PreferredSizeWidget {

  final List<Widget> rightWidgets;
  final List<Widget> leftWidgets;
  const ThAppBar({super.key,this.rightWidgets=const [],this.leftWidgets=const []});

  List<Widget> spaced(List<Widget> widgets, {double space = 0}) {
    return [
      for (int i = 0; i < widgets.length; i++) ...[
        if (i != 0) SizedBox(width: space),
        widgets[i],
      ]
    ];
  }
  List<Widget> vdivided(List<Widget> widgets, ) {
    return [
      for (int i = 0; i < widgets.length; i++) ...[
        if (i != 0) Padding(padding:EdgeInsets.symmetric(vertical: 8), child: VerticalDivider(thickness: 1,)),
        widgets[i],
      ]
    ];
  }
  @override
  Widget build(BuildContext context) {
    final double screenwidth=MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: NoteStore.isDarkMode?Colors.grey.shade900:Colors.white,
        boxShadow: [
          BoxShadow(
            color: NoteStore.isDarkMode?Colors.white.withAlpha((0.25*255).toInt()):Colors.black.withAlpha((0.25*255).toInt()),
            blurRadius: NoteStore.isDarkMode?0:8,
            offset: const Offset(0, 0.15),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              SizedBox(width: screenwidth<=426?0:16,),
              ...spaced(leftWidgets,space: screenwidth<=426?0:screenwidth<=990?5:16),
              Spacer(),
              ...spaced(space:screenwidth<=426?0:screenwidth<=990?0:16,
                  screenwidth<=426?rightWidgets:vdivided(rightWidgets)),
              SizedBox(width: screenwidth<=990?0:16,),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
