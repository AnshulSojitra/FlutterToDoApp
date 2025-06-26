

import 'package:flutter/material.dart';
import 'package:untitled1/component/ThAppBar.dart';
import 'package:untitled1/component/ThButton.dart';

import 'package:untitled1/component/ThIconBox.dart';
import 'package:untitled1/component/ThSideBar.dart';
import 'package:untitled1/component/ThTextbox.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentUserRole = "admin";
  final TextEditingController myController = TextEditingController();
  final TextEditingController labelController = TextEditingController();
  final List<String> items =[];
  final List<ThButton> labels =[];
  final FocusNode focusNode = FocusNode();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNodelabel = FocusNode();
  final List<Map<String, dynamic>> sidebarUpperItems = [
    {'text':'Notes','icon':'Icons.notes_outlined'},
    {'text':'Reminders','icon':'Icons.notifications_none_outlined'},
    {'text':'Edit Labels','icon':'Icons.notifications_none_outlined'},
    {'text':'Edit Labels','icon':'Icons.mode_edit_outlined'},
  ];
  final List<Map<String, dynamic>> sidebarLowerItems = [
    {'text':'Archive','icon':'Icons.archive_outlined'},
    {'text':'Bin','icon':'Icons.delete_outline'},
  ];

  Icon logo(String iconName) {
    if (iconName == "home") return Icon(Icons.dashboard);
    if (iconName == "person") return Icon(Icons.person);
    if (iconName == "settings") return Icon(Icons.settings);
    return Icon(Icons.dashboard);
  }
  bool opensidebar=true;
  bool showicontext=true;
  bool addclick=false;
  bool isGridview=true;
  double iconsize=22;
  double titlesize=20;
  double width=40;
  @override
  void initState() {
    super.initState();
    focusNode1.addListener(() {
      if (!focusNode1.hasFocus) {
        width=40;
        iconsize=22;
        titlesize=20;
        showicontext=true;
        setState(() {});
      }
    });
  }
  void toggleview(){
    if(isGridview){
      isGridview=false;
    }else{
      isGridview=true;
    }
    setState(() {});
  }
  void searchbar(){
    width=160;
    iconsize=0;
    titlesize=0;
    showicontext=false;
    setState(() {});
  }
  void addlabel(){
    String text = labelController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        labelController.clear();
      labels.add(
        ThButton(variant: 'plain',text: opensidebar?text:'',icon: Icon(Icons.label_important_outline),onPress: (){},)
      );
      });
    }
    FocusScope.of(context).requestFocus(focusNodelabel);
    setState(() {});
  }
  void addnote(){

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
      FocusScope.of(context).requestFocus(focusNode);
    }
    setState(() {});
  }
  Widget android(){
    final screenwidth=MediaQuery.of(context).size.width;
  return
    Scaffold(
      backgroundColor: Colors.white,
      appBar: ThAppBar(
        leftWidgets: [
          showicontext?IconButton(icon:Icon(Icons.featured_play_list,size: iconsize,),onPressed: (){
            if(opensidebar==true){
              opensidebar=false;
            }else if(opensidebar==false){
              opensidebar=true;
            }
            setState(() {});
          },):null,
          showicontext?Text('Keep', style: TextStyle(fontSize: titlesize, fontFamily: 'GilroyFont')):null,

          ThTextbox(
            focusNode: focusNode1,
            onTap: searchbar,
            width: width,
            height: 40,
            text: '',
            prefixicon: Icon(Icons.search,),
          )//SearchBar
        ].whereType<Widget>().toList(),
        rightWidgets: [
          IconButton(
            constraints: BoxConstraints(
              minWidth: 20,
              minHeight:20,
            ),
            tooltip: 'Refresh',
            icon: Icon(Icons.refresh,size:18,),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
            },
          ), //Refresh
          IconButton(

            icon: isGridview?Icon(Icons.format_list_bulleted_outlined,size:18,):Icon(Icons.grid_view_outlined,size: 18,),
            tooltip: 'Listview',
            onPressed: toggleview,
            constraints: BoxConstraints(
              minWidth: 20,

            ),
          ),//ListView
          IconButton(
            icon: Icon(Icons.settings_outlined,size:18,),
            tooltip: 'Settings',
            onPressed: () {},
            constraints: BoxConstraints(
              minWidth:20,
            ),
          ),//Settings
          IconButton(
            icon: Icon(Icons.apps,size:18,),
            tooltip: 'Apps',
            onPressed: () {},
            constraints: BoxConstraints(
              minWidth:20,

            ),
          )//Apps
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
                                focusNode: focusNode,
                                onTap:(){opensidebar=false;setState(() {});},
                                onSubmitted: (value) => addnote(),
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
                                      onPressed: addnote,
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
                                isGridview?GridView.builder(
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
                                                ),//Edit button on note
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.delete_outline, size: 20),
                                                  tooltip: 'Delete',
                                                ),//Delete button of note
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                    },
                                ):
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: items.length,
                                  itemBuilder:(context,index){
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(width: 2,color: Colors.deepPurpleAccent),
                                      ),

                                      child: Padding(
                                        padding: EdgeInsets.all(screenwidth<=847?7.60:10),
                                        child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(items[index], style: TextStyle(fontSize: 18),
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              Spacer(),
                                              IconButton(onPressed: (){}, icon: Icon(Icons.edit_outlined,size: 20,),tooltip: 'Edit',),
                                              IconButton(onPressed: (){}, icon: Icon(Icons.delete_outline,size: 20,),tooltip: 'Delete',)
                                            ]),
                                      ),
                                    );
                                  }, separatorBuilder: (BuildContext context, int index) =>SizedBox(height: 10,),
                                )
                            ],
                          ),
                        ),
                    ),
                  ),
                ),
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
              ThButton(variant: 'plain', text: 'Edit labels', icon: Icon(Icons.mode_edit_outlined, size: 16),
                onPress: (){
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                    title: Text('Add Label'),
                    content: SizedBox(
                      height: 100,
                      child: Column(
                        spacing: 8,
                        children:[
                          ThTextbox(text: 'Enter name',controller: labelController,focusNode:focusNodelabel,onSubmitted: (x){addlabel();},),
                          Row(
                            spacing: 8,
                            children: [
                              ThButton(text: 'Add',variant: 'primary',onPress: addlabel,),
                              ThButton(variant: 'dark-outline',text: 'Cancel',onPress: (){
                                Navigator.of(context).pop();
                              },)
                            ],
                          )
                        ]
                      ),
                    ),
                  );
                  });
                },
              ),
              ...labels
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
    final screenwidth=MediaQuery.of(context).size.width;
    return screenwidth<=426?android():
    Scaffold(

      backgroundColor: Colors.white,
      appBar: ThAppBar(
        leftWidgets: [
          IconButton(icon:Icon(Icons.featured_play_list,size:  screenwidth<=990?20:30,),onPressed: (){
            if(opensidebar==true){
              opensidebar=false;
            }else{
              opensidebar=true;
            }
            setState(() {});
          },),
          Text('Keep', style: TextStyle(fontSize:  screenwidth<=990?16:25, fontFamily: 'GilroyFont')),
          // SizedBox(width:  MediaQuery.of(context).size.width<=990?screenwidth*0.2:100),
          ThTextbox(
            width: screenwidth<=990?screenwidth*0.3:400,
            height: 40,
            text: 'Search',
            prefixicon: Icon(Icons.search),
          )
        ],
        rightWidgets: [
          IconButton(
            constraints: BoxConstraints(
                minWidth: screenwidth<=990?screenwidth*0.04:20,
                minHeight: screenwidth<=990?screenwidth*0.02:20,
            ),
            tooltip: 'Refresh',
            icon: Icon(Icons.refresh,size:20,),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
            },
          ),
          IconButton(
            icon: isGridview?Icon(Icons.format_list_bulleted_outlined,size: 20,):Icon(Icons.grid_view_outlined,size: 20,),
            tooltip: isGridview?'Listview':'Gridview',
            onPressed: toggleview,
            constraints: BoxConstraints(
                minWidth: screenwidth<=990?screenwidth*0.02:20,

            ),
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined,size:20,),
            tooltip: 'Settings',
            onPressed: () {},
            constraints: BoxConstraints(
              minWidth: screenwidth<=990?screenwidth*0.02:20,
            ),
          ),
          IconButton(
            icon: Icon(Icons.apps,size:20,),
            tooltip: 'Apps',
            onPressed: () {},
            constraints: BoxConstraints(
              minWidth: screenwidth<=990?screenwidth*0.02:20,

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
                width: opensidebar? screenwidth<=990?172:240:74,
                color: Colors.white70.withAlpha((0.9 * 255).toInt()),
                upperbuttons: [
                  ThButton(variant: 'plain', text: opensidebar?'Notes':'', icon: Icon(Icons.notes_outlined, size: 22),onpage: true,onPress: (){},),
                  ThButton(onPress:(){},variant: 'plain', text:opensidebar? 'Reminders':'', icon: Icon(Icons.notifications_none_outlined, size: 22,)),
                  ThButton(variant: 'plain', text: opensidebar?'Edit labels':'', icon: Icon(Icons.mode_edit_outlined, size: 22),
                      onPress: (){
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: Text('Add Label'),
                        content: SizedBox(
                          height: 100,
                          child: Column(
                            spacing: 8,
                              children:[
                            ThTextbox(text: 'Enter name',controller: labelController,focusNode:focusNodelabel,onSubmitted:(x){addlabel();}),
                            Row(
                              spacing: 8,
                              children: [
                                ThButton(text: 'Add',variant: 'primary',onPress: addlabel,),
                                ThButton(variant: 'dark-outline',text: 'Cancel',onPress: (){
                                  Navigator.of(context).pop();
                                },)
                              ],
                            )
                          ]
                          ),
                        ),
                      );
                    });
                      },
                  ),
                  ...labels
                ],
                lowerbuttons: [
                  ThButton(variant: 'plain', text:opensidebar? 'Archive':'', icon: Icon(Icons.archive_outlined,size: 22,),onPress: (){},),
                  ThButton(variant: 'plain', text:opensidebar? 'Bin':'', icon: Icon(Icons.delete_outline,size: 22,),onPress: (){},),
                ],
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
                                    focusNode: focusNode,
                                    onSubmitted: (value){addnote();},
                                    controller: myController,
                                    text: 'Take a note',
                                    width: 700,
                                    height: 60,
                                    sufixicons: SizedBox(
                                      width: 80,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(icon: Icon(Icons.add), onPressed:addnote,tooltip: 'Add note',),
                                          IconButton(icon: Icon(Icons.image_outlined), tooltip: 'Add image',onPressed: () {
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if(addclick)
                                    isGridview?GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: screenwidth<=1245?screenwidth<=847?1:2:3, // 2 items per row
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
                                            padding: EdgeInsets.all(screenwidth<=847?7.60:10),
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
                                    ):
                                  ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                    itemCount: items.length,
                                      itemBuilder:(context,index){
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(width: 2,color: Colors.deepPurpleAccent),
                                          ),

                                          child: Padding(
                                            padding: EdgeInsets.all(screenwidth<=847?7.60:10),
                                            child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(items[index], style: TextStyle(fontSize: 18),
                                                      softWrap: true,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  IconButton(onPressed: (){}, icon: Icon(Icons.edit_outlined,size: 20,),tooltip: 'Edit',),
                                                  IconButton(onPressed: (){}, icon: Icon(Icons.delete_outline,size: 20,),tooltip: 'Delete',)
                                                ]),
                                          ),
                                        );
                                      }, separatorBuilder: (BuildContext context, int index) =>SizedBox(height: 10,),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
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
