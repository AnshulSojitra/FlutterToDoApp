import 'package:flutter/material.dart';
import 'package:untitled1/component/ThAppBar.dart';
import 'package:untitled1/component/ThButton.dart';
import 'package:untitled1/component/ThFooter.dart';
import 'package:untitled1/component/ThIconBox.dart';
import 'package:untitled1/component/ThSideBar.dart';
import 'package:untitled1/component/ThTextbox.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentUserRole = "user";
  final TextEditingController myController = TextEditingController();
  final List<String> items =[];
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
  void note(){
    String text = myController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        items.add(text);   // Add new item to list
        myController.clear(); // Clear text field
        addclick = true;      // Show the list
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ThAppBar(
        leftWidgets: [
          Icon(Icons.home, size: 30),
          Text('Keep', style: TextStyle(fontSize: 25, fontFamily: 'GilroyFont')),
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
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ThIconBox(
                                    controller: myController,
                                    text: 'Take a note',
                                    width: 700,
                                    height: 60,
                                    sufixicons: SizedBox(
                                      width: 80,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(icon: Icon(Icons.add), onPressed:note),
                                          IconButton(icon: Icon(Icons.image_outlined), onPressed: () {
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if(addclick)
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3, // 2 items per row
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 3, // Adjust height vs width
                                      ),
                                      itemCount: items.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(width: 2,color: Colors.deepPurpleAccent),
                                          ),

                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                              Expanded(
                                                child: Text(items[index], style: TextStyle(fontSize: 18),
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 5,
                                                ),
                                              ),
                                              Spacer(),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                  children:[
                                                IconButton(onPressed: (){}, icon: Icon(Icons.edit_outlined,size: 20,),tooltip: 'Edit',),
                                                IconButton(onPressed: (){}, icon: Icon(Icons.delete_outline,size: 20,),tooltip: 'Delete',)
                                              ])
                                            ]),
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
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
