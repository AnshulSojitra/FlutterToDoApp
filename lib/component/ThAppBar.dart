import 'package:flutter/material.dart';
import 'dart:io';


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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.25*255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 0.15),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Expanded(
            child: Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width<=426?0:16,),
                ...spaced(leftWidgets,space: MediaQuery.of(context).size.width<=426?5:MediaQuery.of(context).size.width<=990?5:16),
                Spacer(),
                ...spaced(space: MediaQuery.of(context).size.width<=426?0:MediaQuery.of(context).size.width<=990?0:16,vdivided(rightWidgets)),
                SizedBox(width: MediaQuery.of(context).size.width<=990?0:16,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
