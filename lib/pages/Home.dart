import 'package:flutter/material.dart';
import 'package:untitled1/component/ThAppBar.dart';
import 'package:untitled1/component/ThButton.dart';
import 'package:untitled1/component/ThIconBox.dart';
import 'package:untitled1/component/ThSideBar.dart';
import 'package:untitled1/component/ThTextbox.dart';

import 'package:untitled1/pages/NoteStore.dart';

import 'Bin.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentUserRole = "admin";
  final TextEditingController notecontroller = TextEditingController();
  final TextEditingController labelController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  late PageController pageController;
  final List<String> items =[];
  final List<String> deleteditems =[];
  final List<ThButton> labels =[];
  final FocusNode notefocusNode = FocusNode();
  final FocusNode searchfocusNode = FocusNode();
  final FocusNode focusNodelabel = FocusNode();

  String searchQuery = '';
  late int editindex;
  int currentpageindex=0;
  int count=-1;

  bool opensidebar=true;
  bool showicontext=true;
  bool addclick=false;
  bool isGridview=true;
  bool isediting=false;
  bool deleteclick=false;
  bool run=false;
  bool isSearching=false;
  double iconsize=22;
  double titlesize=20;
  double width=40;
  late List<Map<String, dynamic>> sidebarUpperItems=[];
  late List<Map<String, dynamic>> sidebarUpperItemsx=[];
  late List<Map<String, dynamic>> sidebarLowerItems=[];


  @override
  void initState() {
    super.initState();
    run=true;
    sidebarUpperItems=[
      {'variant':'plain','text':'Notes','icon':Icons.notes_outlined,'onpage':true,'onPress':(){}},
      {'variant':'plain','text':'Reminders','icon':Icons.notifications_none_outlined,'onpage':false,'onPress':(){}},
      {'variant':'plain','text':'Edit Labels','icon':Icons.mode_edit_outlined,'onpage':false,
        'onPress':(){
          showDialog(context: context, builder: (context){
            return AlertDialog(
              backgroundColor: NoteStore.isDarkMode?Colors.grey.shade900:Colors.white,
              title: Text('Add Label',
              style: TextStyle(color: NoteStore.isDarkMode?Colors.white:Colors.black,),
                ),
              content: SizedBox(
                height: 100,
                child: Column(
                    spacing: 8,
                    children:[
                      ThTextbox(text: 'Enter name',controller: labelController,focusNode:focusNodelabel,
                          onSubmitted:(x){
                            addlabel();
                            FocusScope.of(context).requestFocus(focusNodelabel);
                            setState(() {});
                      }),
                      Row(
                        spacing: 8,
                        children: [
                          ThButton(text: 'Add',variant: 'primary',onPress: addlabel,),
                          ThButton(variant: NoteStore.isDarkMode?'primary':'dark-outline',text: 'Cancel',onPress: (){
                            Navigator.of(context).pop();
                          },)
                        ],
                      )
                    ]
                ),
              ),
            );
          });
        }},
      ...NoteStore.labels
    ];
    sidebarLowerItems=[
      {'variant':'plain','text':'Settings','icon':Icons.settings_outlined,'onpage':false,'onPress':(){}},
      {'variant':'plain','text':'Bin','icon':Icons.delete_outline,'onpage':false,'onPress':(){
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Bin(deleteditemslist: NoteStore.deletedItems,)),
          );
        });
      }},
    ];
    searchfocusNode.addListener(() {
      if (!searchfocusNode.hasFocus) {
        width=40;
        iconsize=22;
        titlesize=20;
        isSearching?showicontext=false:showicontext=true;
        isSearching=false;
        setState(() {});
      }else{
        isSearching=true;
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
  void addnote(){

    if(MediaQuery.of(context).size.width<=426){
      opensidebar=false;
    }
    String text = notecontroller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        count++;
        // NoteStore.filteredIndex.add(count);
        if(isediting){
          NoteStore.items.removeAt(editindex);
          NoteStore.items.insert(editindex, text);
          isediting=false;
        }
        else {
          NoteStore.items.add(text);
          getSearchedItems();
        }// Add new item to list
        notecontroller.clear(); // Clear text field
        addclick = true;      // Show the list
      });
      FocusScope.of(context).requestFocus(notefocusNode);
    }
    setState(() {});
  }
  // In your _HomeState class (Home.dart)

  void deletenote(int originalIndexInAllItems) {
    if (originalIndexInAllItems >= 0 && originalIndexInAllItems < NoteStore.items.length) {
      setState(() {
        // 1. Get the note to be deleted BEFORE removing it
        String noteToDelete = NoteStore.items[originalIndexInAllItems];

        // 2. Add the note to your deletedItems list (in NoteStore)
        NoteStore.deletedItems.add(noteToDelete); // Or just deleteditems.add(noteToDelete) if you sync them

        // 3. Remove the note from the main items list
        NoteStore.items.removeAt(originalIndexInAllItems);

        // 4. Update filtered lists if searching (as before)
        if (isSearching) {
          // Re-filter the items
          // NoteStore.filteredItems = NoteStore.items
          //     .where((note) => note.toLowerCase().contains(searchQuery.toLowerCase()))
          //     .toList();

          // Re-calculate filteredIndex based on the updated NoteStore.items
          NoteStore.filteredIndex.clear();
          for (int i = 0; i < NoteStore.items.length; i++) {
            if (NoteStore.items[i].toLowerCase().contains(searchQuery.toLowerCase())) {
              NoteStore.filteredIndex.add(i);
            }
          }
          // if (NoteStore.filteredItems.isEmpty) {
          //   // Potentially clear search or show a "no results" message
          // }
        }
      });
    } else {
      print("Error: Attempted to delete item with invalid index: $originalIndexInAllItems");
    }
  }
  void editnote(int index){
    editindex=index;
    setState(() {
      isediting=true;
      notecontroller.text=NoteStore.items[index];
    });
  }
  void getSearchedItems(){
    searchQuery = searchController.text;
    NoteStore.filteredIndex.clear();
    for (int i = 0; i < NoteStore.items.length; i++) {
      if (NoteStore.items[i].toLowerCase().contains(searchQuery.toLowerCase())) {
        NoteStore.filteredIndex.add(i);
      }
    }
    setState(() {});
  }
  void addlabel(){
    String text = labelController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        NoteStore.labels.add( {'variant':'plain','text':text,'icon':Icons.label_important_outline,'onpage':false,'onPress':(){}});
        sidebarUpperItems.add(
            {'variant':'plain','text':text,'icon':Icons.label_important_outline,'onpage':false,'onPress':(){}}
        );
        labelController.clear();
      });
      FocusScope.of(context).requestFocus(focusNodelabel);
    }
    setState(() {});
  }

  Widget android(double screenwidth){
    final double screenheight=MediaQuery.of(context).size.height;
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
              controller: searchController,
              focusNode: searchfocusNode,
              onTap: searchbar,
              width: isSearching?160:width,
              height: 40,
              text: '',
              prefixicon: Icon(Icons.search,),
              onChanged: (value) {
                getSearchedItems();
              },
            )//SearchBar
          ].whereType<Widget>().toList(),
          rightWidgets: [
            IconButton(
              constraints: BoxConstraints(
                minWidth: screenwidth<=990?screenwidth*0.04:20,
                minHeight: screenwidth<=990?screenwidth*0.02:20,
              ),
              tooltip: NoteStore.isDarkMode?'Light Mode':'Dark Mode',
              icon: Icon(NoteStore.isDarkMode?Icons.light_mode_outlined:Icons.dark_mode_outlined,size:18,),
              onPressed: () {
                if(NoteStore.isDarkMode)
                  NoteStore.isDarkMode=false;
                else
                  NoteStore.isDarkMode=true;
                setState(() {});
              },
            ),
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
            //Settings
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
                                        focusNode: notefocusNode,
                                        onTap:(){opensidebar=false;setState(() {});},
                                        onSubmitted: (value) => addnote(),
                                        controller: notecontroller,
                                        text: 'Take a note',
                                        width: 700,
                                        height: 60,
                                        sufixicons: SizedBox(
                                          width: 96,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: addnote,
                                                tooltip: 'Add note',
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.image_outlined,),
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
                                      if(NoteStore.items.isEmpty)
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: screenheight/2-200),
                                          child: Column(
                                            children: [
                                              Icon(Icons.lightbulb_outline,size: 100,color: Colors.black.withOpacity(0.1),),
                                              Text('Notes that you add appear here',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black.withOpacity(0.6)
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if(isSearching&&NoteStore.filteredIndex.isEmpty)
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: screenheight/2-200),
                                          child: Column(
                                            children: [
                                              Icon(Icons.search_off,size: 100,color: Colors.black.withOpacity(0.1),),
                                              Text('No matching results!',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black.withOpacity(0.6)
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if(addclick||NoteStore.items.isNotEmpty)
                                        isGridview?GridView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: 1,
                                          ),
                                          itemCount: isSearching?NoteStore.filteredIndex.length:NoteStore.items.length,
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
                                                        isSearching?NoteStore.items[NoteStore.filteredIndex[index]]:NoteStore.items[index],
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
                                                          onPressed: ()=>editnote(NoteStore.filteredIndex.length>0?NoteStore.filteredIndex[index]:index),
                                                          icon: Icon(Icons.edit_outlined, size: 20),
                                                          tooltip: 'Edit',
                                                        ),//Edit button on note
                                                        IconButton(
                                                          onPressed:isediting?(){}: (){
                                                            if (isSearching && index < NoteStore.filteredIndex.length) {
                                                              // Get the ACTUAL original index from the filteredIndex
                                                              int originalIndexToDelete = NoteStore.filteredIndex[index];
                                                              deletenote(originalIndexToDelete);
                                                            } else if (!isSearching && index < NoteStore.items.length) {
                                                              // If not searching, the 'index' from GridView/ListView IS the original index
                                                              deletenote(index);
                                                            }
                                                          },
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
                                          itemCount: isSearching?NoteStore.filteredIndex.length:NoteStore.items.length,
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
                                                        child: Text(isSearching?NoteStore.items[NoteStore.filteredIndex[index]]:NoteStore.items[index],style: TextStyle(fontSize: 18),
                                                          softWrap: true,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      IconButton(
                                                        onPressed: ()=>editnote(NoteStore.filteredIndex.length>0?NoteStore.filteredIndex[index]:index),
                                                        icon: Icon(Icons.edit_outlined,size: 20,),tooltip: 'Edit',
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons.delete_outline,size: 20,),tooltip: 'Delete',
                                                        onPressed:isediting?(){}: (){
                                                          if (isSearching && index < NoteStore.filteredIndex.length) {
                                                            // Get the ACTUAL original index from the filteredIndex
                                                            int originalIndexToDelete = NoteStore.filteredIndex[index];
                                                            deletenote(originalIndexToDelete);
                                                          } else if (!isSearching && index < NoteStore.items.length) {
                                                            // If not searching, the 'index' from GridView/ListView IS the original index
                                                            deletenote(index);
                                                          }
                                                        },
                                                      )
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
                    width: opensidebar? screenwidth<=990?172:240:74,
                    color: Colors.white70.withAlpha((0.9 * 255).toInt()),
                    upperbuttons: sidebarUpperItems.map((item){
                      return ThButton(variant:item['variant'],text: opensidebar?item['text']:'',onPress: item['onPress'],icon: Icon(item['icon'],size: 22,),onpage: item['onpage'],);
                    }).toList(),
                    lowerbuttons: sidebarLowerItems.map((item){
                      return ThButton(variant:item['variant'],text: opensidebar?item['text']:'',onPress: item['onPress'],icon: Icon(item['icon'],size: 22,),onpage: item['onpage'],);
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      );
  }
  @override
  Widget build(BuildContext context) {
    if(searchController.text.isEmpty){
      isSearching=false;
    }else{isSearching=true;}
    // NoteStore.filteredItems= NoteStore.items.where((note) => note.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    print(NoteStore.filteredIndex);
    return Builder(
      builder: (context) {
        final screenwidth=MediaQuery.of(context).size.width;
        final screenheight=MediaQuery.of(context).size.height;
        return screenwidth<=426?android(screenwidth):
        Scaffold(

          backgroundColor: NoteStore.isDarkMode?Colors.black.withOpacity(0.9):Colors.white,
          appBar: ThAppBar(
            leftWidgets: [
              IconButton(
                icon:Icon(Icons.featured_play_list, size:  screenwidth<=990?20:30,color: NoteStore.isDarkMode?Colors.white:Colors.black,),
                onPressed: (){
                if(opensidebar==true){
                  opensidebar=false;
                }else{
                  opensidebar=true;
                }
                setState(() {});
              },),
              Text('Keep',
                  style: TextStyle(
                    color:NoteStore.isDarkMode?Colors.white:Colors.black ,
                      fontSize:  screenwidth<=990?22:25,
                      fontFamily: 'GilroyFont')
              ),
              // SizedBox(width:  MediaQuery.of(context).size.width<=990?screenwidth*0.2:100),
              ThTextbox(
                focusNode: searchfocusNode,
                controller: searchController,
                width: screenwidth<=990?screenwidth*0.3:400,
                height: 40,
                text: 'Search',
                prefixicon: Icon(Icons.search,color: NoteStore.isDarkMode?Colors.white:Colors.black,),
                onChanged: (value) {
                  searchQuery = searchController.text;
                  NoteStore.filteredIndex.clear();
                  for (int i = 0; i < NoteStore.items.length; i++) {
                    if (NoteStore.items[i].toLowerCase().contains(searchQuery.toLowerCase())) {
                      NoteStore.filteredIndex.add(i);
                    }
                  }
                  setState(() {});
                },
              )
            ],
            rightWidgets: [
              IconButton(
                constraints: BoxConstraints(
                  minWidth: screenwidth<=990?screenwidth*0.04:20,
                  minHeight: screenwidth<=990?screenwidth*0.02:20,
                ),
                tooltip: NoteStore.isDarkMode?'Light Mode':'Dark Mode',
                icon: Icon(
                  NoteStore.isDarkMode?Icons.light_mode_outlined:Icons.dark_mode_outlined,size:18,
                  color: NoteStore.isDarkMode?Colors.white:Colors.black,
                ),
                onPressed: () {
                  if(NoteStore.isDarkMode)
                    NoteStore.isDarkMode=false;
                  else
                    NoteStore.isDarkMode=true;
                  setState(() {});
                },
              ),
              IconButton(
                constraints: BoxConstraints(
                    minWidth: screenwidth<=990?screenwidth*0.04:20,
                    minHeight: screenwidth<=990?screenwidth*0.02:20,
                ),
                tooltip: 'Refresh',
                icon: Icon(
                  Icons.refresh,
                  color: NoteStore.isDarkMode?Colors.white:Colors.black,
                  size:20,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  isGridview?Icons.format_list_bulleted_outlined:Icons.grid_view_outlined,
                  color: NoteStore.isDarkMode?Colors.white:Colors.black,
                  size: 20,
                ),
                tooltip: isGridview?'Listview':'Gridview',
                onPressed: toggleview,
                constraints: BoxConstraints(
                    minWidth: screenwidth<=990?screenwidth*0.02:20,

                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.apps,
                  color: NoteStore.isDarkMode?Colors.white:Colors.black,
                  size:20,
                ),
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
                    color: NoteStore.isDarkMode?Colors.grey.shade900:Colors.white70.withAlpha((0.9 * 255).toInt()),
                    upperbuttons: sidebarUpperItems.map((item){
                      return ThButton(variant:item['variant'],text: opensidebar?item['text']:'',onPress: item['onPress'],icon: Icon(item['icon'],size: 22,),onpage: item['onpage'],);
                    }).toList(),
                    lowerbuttons: sidebarLowerItems.map((item){
                      return ThButton(variant:item['variant'],text: opensidebar?item['text']:'',onPress: item['onPress'],icon: Icon(item['icon'],size: 22,),onpage: item['onpage'],);
                    }).toList(),
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
                                        focusNode: notefocusNode,
                                        onSubmitted: (value){addnote();},
                                        controller: notecontroller,
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
                                                onPressed:addnote,
                                                tooltip: 'Add note',
                                                color: NoteStore.isDarkMode?Colors.white:Colors.black,
                                              ),
                                              IconButton(
                                                  icon: Icon(Icons.image_outlined),
                                                  tooltip: 'Add image',
                                                  color: NoteStore.isDarkMode?Colors.white:Colors.black,
                                                  onPressed: () {}
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if(NoteStore.items.isEmpty)
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: screenheight/2-200),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.lightbulb_outline,size: 100,
                                                color: NoteStore.isDarkMode?Colors.white.withOpacity(0.3):Colors.black.withOpacity(0.1),
                                              ),
                                              Text('Notes that you add appear here',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize:screenwidth<=545?20: 24,
                                                    color: NoteStore.isDarkMode?Colors.white.withOpacity(0.6):Colors.black.withOpacity(0.6)
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      //No matching results

                                      if(isSearching&&NoteStore.filteredIndex.isEmpty)
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: screenheight/2-200),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.search_off,size: 100,
                                                color: NoteStore.isDarkMode?Colors.white.withOpacity(0.3):Colors.black.withOpacity(0.1),
                                              ),
                                              Text('No matching result found!',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize:screenwidth<=545?20: 24,
                                                    color: NoteStore.isDarkMode?Colors.white.withOpacity(0.6):Colors.black.withOpacity(0.6)
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if(addclick||NoteStore.items.isNotEmpty)
                                        isGridview?GridView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: screenwidth<=1245?screenwidth<=847?1:2:3, // 2 items per row
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: 3, // Adjust height vs width
                                          ),

                                          itemCount: isSearching?NoteStore.filteredIndex.length:NoteStore.items.length,
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
                                                    child: Text(
                                                      isSearching?NoteStore.items[NoteStore.filteredIndex[index]]:NoteStore.items[index],
                                                      style: TextStyle(fontSize: 18,color: NoteStore.isDarkMode?Colors.white:Colors.black),
                                                      softWrap: true,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 5,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                      children:[
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.edit_outlined,size: 20,
                                                        color: NoteStore.isDarkMode?Colors.white:Colors.black,
                                                      ),
                                                      tooltip: 'Edit',
                                                      onPressed: ()=>editnote(NoteStore.filteredIndex.length>0?NoteStore.filteredIndex[index]:index),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.delete_outline,size: 20,
                                                        color: NoteStore.isDarkMode?Colors.white:Colors.black,
                                                      ),
                                                      tooltip: 'Delete',
                                                      onPressed:isediting?(){}: (){
                                                      if (isSearching && index < NoteStore.filteredIndex.length) {
                                                        // Get the ACTUAL original index from the filteredIndex
                                                        int originalIndexToDelete = NoteStore.filteredIndex[index];
                                                        deletenote(originalIndexToDelete);
                                                      } else if (!isSearching && index < NoteStore.items.length) {
                                                        // If not searching, the 'index' from GridView/ListView IS the original index
                                                        deletenote(index);
                                                      }
                                                    },)
                                                  ])
                                                ]),
                                              ),
                                            );
                                          },
                                        ):
                                      ListView.separated(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                        itemCount: isSearching?NoteStore.filteredIndex.length:NoteStore.items.length,
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
                                                        child: Text(
                                                          isSearching?NoteStore.items[NoteStore.filteredIndex[index]]:NoteStore.items[index],
                                                          style: TextStyle(fontSize: 18,color: NoteStore.isDarkMode?Colors.white:Colors.black),
                                                          softWrap: true,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      IconButton(
                                                        onPressed: ()=>editnote(NoteStore.filteredIndex.length>0?NoteStore.filteredIndex[index]:index),
                                                        icon: Icon(
                                                          Icons.edit_outlined,size: 20,
                                                          color: NoteStore.isDarkMode?Colors.white:Colors.black,
                                                        ),
                                                        tooltip: 'Edit',
                                                      ),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.delete_outline,size: 20,
                                                          color: NoteStore.isDarkMode?Colors.white:Colors.black,
                                                        ),
                                                        tooltip: 'Delete',
                                                        onPressed:isediting?(){}: (){
                                                        if (isSearching && index < NoteStore.filteredIndex.length) {
                                                          // Get the ACTUAL original index from the filteredIndex
                                                          int originalIndexToDelete = NoteStore.filteredIndex[index];
                                                          deletenote(originalIndexToDelete);
                                                        } else if (!isSearching && index < NoteStore.items.length) {
                                                          // If not searching, the 'index' from GridView/ListView IS the original index
                                                          deletenote(index);
                                                        }
                                                      },)
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
    );

  }
}
