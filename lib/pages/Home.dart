import 'package:flutter/material.dart';
import 'package:untitled1/component/ThAppBar.dart';
import 'package:untitled1/component/ThButton.dart';
import 'package:untitled1/component/ThDropDown.dart';
import 'package:untitled1/component/ThFooter.dart';
import 'package:untitled1/component/ThIconBox.dart';
import 'package:untitled1/component/ThSideBar.dart';
import 'package:untitled1/component/ThBreadCrumb.dart';
import 'package:untitled1/component/ThTextbox.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentUserRole = "user";

  final List<Map<String, dynamic>> menuItems = [
    {"label": "Home", "icon": "home", "allowFor": ["user", "admin"]},
    {"label": "Profile", "icon": "person", "allowFor": ["admin"]},
    {"label": "Settings", "icon": "settings", "allowFor": ["user", "admin"]},
  ];

  Icon logo(String iconName) {
    if (iconName == "home") return Icon(Icons.dashboard);
    if (iconName == "person") return Icon(Icons.person);
    if (iconName == "settings") return Icon(Icons.settings);
    return Icon(Icons.dashboard);
  }
  bool addclick=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ThAppBar(
        leftWidgets: [
          Icon(Icons.home, size: 30),
          Text('Website', style: TextStyle(fontSize: 25, fontFamily: 'GilroyFont')),
          SizedBox(width: 100),
          ThTextbox(
            width: 400,
            height: 40,
            text: 'Search',
            prefixicon: Icon(Icons.search),
          )
        ],
        rightWidgets: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
            },
          ),
          IconButton(icon: Icon(Icons.format_list_bulleted_outlined), onPressed: () {}),
          IconButton(icon: Icon(Icons.settings_outlined), onPressed: () {}),
          IconButton(icon: Icon(Icons.apps), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ThSideBar(
                upperbuttons: [
                  ThButton(variant: 'plain', text: 'Notes', icon: Icon(Icons.notes_outlined, size: 22)),
                  ThButton(variant: 'plain', text: 'Reminders', icon: Icon(Icons.notifications_none_outlined, size: 22)),
                  ThButton(variant: 'plain', text: 'Edit labels', icon: Icon(Icons.mode_edit_outlined, size: 22)),
                ],
                lowerbuttons: [
                  ThButton(variant: 'plain', text: 'Archive', icon: Icon(Icons.archive_outlined)),
                  ThButton(variant: 'plain', text: 'Bin', icon: Icon(Icons.delete_outline)),
                ],
                width: 240,
                color: Colors.white70.withAlpha((0.9 * 255).toInt()),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ThIconBox(
                                  text: 'Take a note',
                                  width: 700,
                                  height: 60,
                                  sufixicons: SizedBox(
                                    width: 80,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(icon: Icon(Icons.add), onPressed: () {}),
                                        IconButton(icon: Icon(Icons.image_outlined), onPressed: () {}),
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    ThFooter(
                      rightWidgets: [
                        ThButton(variant: 'dark-outline', text: 'Back'),
                        ThButton(variant: 'primary', text: 'Continue'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
