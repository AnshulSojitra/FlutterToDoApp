

import 'package:flutter/material.dart';
import 'package:untitled1/component/ThAppBar.dart';
import 'package:untitled1/component/ThButton.dart';
import 'package:untitled1/component/ThFooter.dart';
import 'package:untitled1/component/ThIconBox.dart';
import 'package:untitled1/component/ThSideBar.dart';
import 'package:untitled1/component/ThTextbox.dart';
import 'dart:io';
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
  bool opensidebar=true;
  bool addclick=false;
  void note(){
    if(MediaQuery.of(context).size.width<=426){
      opensidebar=false;
    }
    String text = myController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        items.add(text);   // Add new item to list
        myController.clear(); // Clear text field
        addclick = true;      // Show the list
      });
    }
    setState(() {});
  }
  Widget android(){

  return
    Scaffold(
      backgroundColor: Colors.white,
      appBar: ThAppBar(
        leftWidgets: [
          IconButton(icon:Icon(Icons.featured_play_list,size: 22,),onPressed: (){
            if(opensidebar==true){
              opensidebar=false;
            }else if(opensidebar==false){
              opensidebar=true;
            }
            setState(() {});
          },),
          Text('Keep', style: TextStyle(fontSize: 20, fontFamily: 'GilroyFont')),

          ThTextbox(
            width: 150,
            height: 40,
            text: '',
            prefixicon: Icon(Icons.search,),
          )
        ],

      ),
      body: Stack(
    children: [
    // Main Content (Row without sidebar)
    GestureDetector(
      onTap:(){

        opensidebar=false;
        setState(() {});
      },
      child: Row(
      children: [
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
                                onTap:(){opensidebar=false;setState(() {});},
                                onSubmitted: (value) => note(),
                                controller: myController,
                                text: 'Take a note',
                                width: 700,
                                height: 60,
                                sufixicons: SizedBox(
                                width: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: note,
                                      tooltip: 'Add note',
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.image_outlined),
                                      tooltip: 'Add image',
                                      onPressed: () {
                                        if(MediaQuery.of(context).size.width<=426){
                                          opensidebar=false;
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                ),
                              ),
                              if (addclick)
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    return Container(

                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(width: 2, color: Colors.deepPurpleAccent),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                items[index],
                                                style: TextStyle(fontSize: 18),
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 5,
                                              ),
                                            ),
                                            Spacer(),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.edit_outlined, size: 20),
                                                  tooltip: 'Edit',
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.delete_outline, size: 20),
                                                  tooltip: 'Delete',
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
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
                  ThButton(variant: 'dark-outline', text: 'Back',onPress: (){
                    print('Clicked');
                  },),
                  ThButton(variant: 'primary', text: 'Continue'),
                ],
              ),
            ],
            ),
          ),
      ],
      ),
    ),

    if (opensidebar)
      Positioned(
        top: 0,
        left: 0,
        bottom: 0,
        child: Container(
          width: 160,
          color: Colors.white.withOpacity(0.95),
          child: ThSideBar(

            upperbuttons: [
              ThButton(variant: 'plain', text: 'Notes', icon: Icon(Icons.notes_outlined, size: 16), onpage: true),
              ThButton(variant: 'plain', text: 'Reminders', icon: Icon(Icons.notifications_none_outlined, size: 16)),
              ThButton(variant: 'plain', text: 'Edit labels', icon: Icon(Icons.mode_edit_outlined, size: 16)),
            ],
            lowerbuttons: [
              ThButton(variant: 'plain', text: 'Archive', icon: Icon(Icons.archive_outlined)),
              ThButton(variant: 'plain', text: 'Bin', icon: Icon(Icons.delete_outline)),
            ],
            width: 160,
            color: Colors.white70.withAlpha((0.9 * 255).toInt()),
          ),
        ),
      ),
    ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    double screenwidth=MediaQuery.of(context).size.width;
    return MediaQuery.of(context).size.width<=426?android():
    Scaffold(
      backgroundColor: Colors.white,
      appBar: ThAppBar(
        leftWidgets: [
          IconButton(icon:Icon(Icons.featured_play_list,size:  MediaQuery.of(context).size.width<=990?20:30,),onPressed: (){
            if(opensidebar==true){
              opensidebar=false;
            }else{
              opensidebar=true;
            }
            setState(() {});
          },),
          Text('Keep', style: TextStyle(fontSize:  MediaQuery.of(context).size.width<=990?16:25, fontFamily: 'GilroyFont')),
          // SizedBox(width:  MediaQuery.of(context).size.width<=990?screenwidth*0.2:100),
          ThTextbox(
            width: MediaQuery.of(context).size.width<=990?screenwidth*0.3:400,
            height: 40,
            text: 'Search',
            prefixicon: Icon(Icons.search),
          )
        ],
        rightWidgets: [
          IconButton(
            constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width<=990?screenwidth*0.04:20,
                minHeight: MediaQuery.of(context).size.width<=990?screenwidth*0.02:20,
            ),
            tooltip: 'Refresh',
            icon: Icon(Icons.refresh,size:MediaQuery.of(context).size.width<=990?15:20,),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
            },
          ),
          IconButton(

            icon: Icon(Icons.format_list_bulleted_outlined,size: MediaQuery.of(context).size.width<=990?15:20,),
            tooltip: 'Listview',
            onPressed: () {},
            constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width<=990?screenwidth*0.02:20,

            ),
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined,size:MediaQuery.of(context).size.width<=990?15:20,),
            tooltip: 'Settings',
            onPressed: () {},
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width<=990?screenwidth*0.02:20,
            ),
          ),
          IconButton(
            icon: Icon(Icons.apps,size:MediaQuery.of(context).size.width<=990?15:20,),
            tooltip: 'Apps',
            onPressed: () {},
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width<=990?screenwidth*0.02:20,

            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ThSideBar(

                upperbuttons: [
                  ThButton(variant: 'plain', text: opensidebar?'Notes':'', icon: Icon(Icons.notes_outlined, size: 22),onpage: true,),
                  ThButton(variant: 'plain', text:opensidebar? 'Reminders':'', icon: Icon(Icons.notifications_none_outlined, size: 22)),
                  ThButton(variant: 'plain', text: opensidebar?'Edit labels':'', icon: Icon(Icons.mode_edit_outlined, size: 22)),
                ],
                lowerbuttons: [
                  ThButton(variant: 'plain', text:opensidebar? 'Archive':'', icon: Icon(Icons.archive_outlined)),
                  ThButton(variant: 'plain', text:opensidebar? 'Bin':'', icon: Icon(Icons.delete_outline)),
                ],
                width: opensidebar? MediaQuery.of(context).size.width<=990?172:240:85,
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
                                    onSubmitted: (value){note();},
                                    controller: myController,
                                    text: 'Take a note',
                                    width: 700,
                                    height: 60,
                                    sufixicons: SizedBox(
                                      width: 80,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(icon: Icon(Icons.add), onPressed:note,tooltip: 'Add note',),
                                          IconButton(icon: Icon(Icons.image_outlined), tooltip: 'Add image',onPressed: () {
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
