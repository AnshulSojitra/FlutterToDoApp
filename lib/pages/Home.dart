import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled1/component/ThAppBar.dart';
import 'package:untitled1/component/ThButton.dart';
import 'package:untitled1/component/ThIconBox.dart';
import 'package:untitled1/component/ThSideBar.dart';
import 'package:untitled1/component/ThTextbox.dart';

import 'package:untitled1/pages/NoteStore.dart';

import 'Bin.dart';
import 'Login.dart';



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
  final List<ThButton> labels =[];
  final FocusNode notefocusNode = FocusNode();
  final FocusNode searchfocusNode = FocusNode();
  final FocusNode focusNodelabel = FocusNode();
  List<QueryDocumentSnapshot> allNotes = [];
  List<QueryDocumentSnapshot> filteredNotes = [];

  String searchQuery = '';
  String editText = '';
  String editid='';
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



  Future<void> logout()async{
    await FirebaseAuth.instance.signOut().then((res) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    });

  }
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
                height: 110,
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
      {'variant':'plain','text':'Log out','icon':Icons.logout,'onpage':false,
        'onPress':()async{
        await logout();
      }},
      {'variant':'plain','text':'Bin','icon':Icons.delete_outline,'onpage':false,'onPress':(){
        setState(() {
          Navigator.pushReplacementNamed(context, '/bin');

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
  void addnote()async{
    await uploadNotesToDatabse();

    if(MediaQuery.of(context).size.width<=426){
      opensidebar=false;
    }
    String text = notecontroller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        count++;
        // NoteStore.filteredIndex.add(count);
        if(isediting){
          isediting=false;
        }
        notecontroller.clear(); // Clear text field
        addclick = true;      // Show the list
      });
      FocusScope.of(context).requestFocus(notefocusNode);
    }
    setState(() {});
  }
  // In your _HomeState class (Home.dart)
  TextSpan _highlightSearchText(String? text, String searchTerm) {
    if (text == null || searchTerm.isEmpty || !isSearching) {
      return TextSpan(
        text: text ?? '',
        style: TextStyle(
          color: NoteStore.isDarkMode ? Colors.white : Colors.black,
          fontSize: 18,
        ),
      );
    }

    List<TextSpan> spans = [];
    String lowerText = text.toLowerCase();
    String lowerSearchTerm = searchTerm.toLowerCase();

    int start = 0;
    int index = lowerText.indexOf(lowerSearchTerm);

    while (index != -1) {
      // Add text before the match
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: TextStyle(
            color: NoteStore.isDarkMode ? Colors.white : Colors.black,
            fontSize: 18,
          ),
        ));
      }

      // Add highlighted match
      spans.add(TextSpan(
        text: text.substring(index, index + searchTerm.length),
        style: TextStyle(
          color: NoteStore.isDarkMode ? Colors.black : Colors.white,
          backgroundColor: Colors.yellow.withOpacity(0.7),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ));

      start = index + searchTerm.length;
      index = lowerText.indexOf(lowerSearchTerm, start);
    }

    // Add remaining text
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: TextStyle(
          color: NoteStore.isDarkMode ? Colors.white : Colors.black,
          fontSize: 18,
        ),
      ));
    }

    return TextSpan(children: spans);
  }

  void editnote(int index){
    editindex=index;
    setState(() {
      isediting=true;

    });
  }
  void searchNotes(String query) {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        filteredNotes = [];
      });
      return;
    }

    setState(() {
      isSearching = true;
      filteredNotes = allNotes.where((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null || data['note'] == null) return false;

        String noteText = data['note'].toString().toLowerCase();
        return noteText.contains(query.toLowerCase());
      }).toList();
    });
  }
  void addlabel()async{
    String text = labelController.text.trim();
    NoteStore.labels.add( {'variant':'plain','text':text,'icon':Icons.label_important_outline,'onpage':false,'onPress':(){}});
    sidebarUpperItems.add(
        {'variant':'plain','text':text,'icon':Icons.label_important_outline,'onpage':false,'onPress':(){}}
    );

        await FirebaseFirestore.instance.collection("Labels").add({
          "label": labelController.text.trim(),
          "creator":FirebaseAuth.instance.currentUser!.uid,
          "timestamp": FieldValue.serverTimestamp(),
        });

        labelController.clear();

      FocusScope.of(context).requestFocus(focusNodelabel);

    setState(() {});
  }
  Future<void> uploadNotesToDatabse ()async{
    try{
      isediting?await FirebaseFirestore.instance.collection("Notes").doc(editid).update({"note":notecontroller.text}):
      notecontroller.text.isNotEmpty?FirebaseFirestore.instance.collection("Notes").add({
        "note": notecontroller.text.trim(),
        "creator":FirebaseAuth.instance.currentUser!.uid,
        "timestamp": FieldValue.serverTimestamp(),
      }):print("no no");
      isediting=false;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }
  Widget android(double screenwidth){
    final double screenheight=MediaQuery.of(context).size.height;
    return
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (){
          searchfocusNode.unfocus();
          setState(() {});
        },
        child: Scaffold(
          backgroundColor: NoteStore.isDarkMode?Colors.black.withOpacity(0.9):Colors.white,
          appBar: ThAppBar(
            leftWidgets: [
              showicontext?IconButton(
                icon:Icon(
                  Icons.featured_play_list,
                  size: iconsize,
                  color: NoteStore.isDarkMode?Colors.white:Colors.black,
                ),
                onPressed: (){
                if(opensidebar==true){
                  opensidebar=false;
                }else if(opensidebar==false){
                  opensidebar=true;
                }
                setState(() {});
              },):null,
              showicontext?Text('Keep',
                  style: TextStyle(
                      fontSize: titlesize,
                      fontFamily: 'GilroyFont',
                      color: NoteStore.isDarkMode?Colors.white:Colors.black
                  )
              ):null,

              ThTextbox(
                onTapOutside: (event) {
                  searchfocusNode.unfocus();
                  setState(() {});
                },
                controller: searchController,
                focusNode: searchfocusNode,
                onTap: searchbar,
                width: isSearching?160:width,
                height: 40,
                text: '',
                prefixicon: Icon(Icons.search,color: NoteStore.isDarkMode?Colors.white:Colors.black,),
                onChanged: (value) => searchNotes(value),
              )//SearchBar
            ].whereType<Widget>().toList(),
            rightWidgets: [
              IconButton(
                constraints: BoxConstraints(
                  minWidth: screenwidth<=990?screenwidth*0.04:20,
                  minHeight: screenwidth<=990?screenwidth*0.02:20,
                ),
                tooltip: NoteStore.isDarkMode?'Light Mode':'Dark Mode',
                icon: Icon(
                  NoteStore.isDarkMode?Icons.light_mode_outlined:Icons.dark_mode_outlined,
                  size:18,
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
                  minWidth: 20,
                  minHeight:20,
                ),
                tooltip: 'Refresh',
                icon: Icon(
                  Icons.refresh,
                  size:18,
                  color: NoteStore.isDarkMode?Colors.white:Colors.black,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
              ), //Refresh
              IconButton(

                icon: Icon(
                  isGridview?Icons.format_list_bulleted_outlined:Icons.grid_view_outlined,
                  size:18,
                  color: NoteStore.isDarkMode?Colors.white:Colors.black,
                ),
                tooltip: 'Listview',
                onPressed: toggleview,
                constraints: BoxConstraints(
                  minWidth: 20,

                ),
              ),//ListView
              //Settings
              IconButton(
                icon: Icon(
                  Icons.apps,
                  size:18,
                  color: NoteStore.isDarkMode?Colors.white:Colors.black,
                ),
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

                                        SizedBox(height: 10),
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
                                                  icon: Icon(
                                                    Icons.add,
                                                    color: NoteStore.isDarkMode?Colors.white:Colors.black,
                                                  ),
                                                  onPressed: notecontroller.text.trimRight().isEmpty? null:addnote,
                                                  tooltip: 'Add note',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        isGridview
                                            ? FutureBuilder(
                                          future: FirebaseFirestore.instance
                                              .collection("Notes")
                                              .orderBy("timestamp")
                                              .where("creator", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Center(
                                                child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
                                              );
                                            }

                                            if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(vertical: screenheight / 2 - 200),
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Icons.lightbulb_outline,
                                                      size: 100,
                                                      color: NoteStore.isDarkMode
                                                          ? Colors.white.withOpacity(0.3)
                                                          : Colors.black.withOpacity(0.1),
                                                    ),
                                                    Text(
                                                      isSearching
                                                          ? 'No notes found matching your search'
                                                          : 'Notes that you add appear here',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: screenwidth <= 545 ? 20 : 24,
                                                        color: NoteStore.isDarkMode
                                                            ? Colors.white.withOpacity(0.6)
                                                            : Colors.black.withOpacity(0.6),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }

                                            // Store all notes for search
                                            if (snapshot.data != null) {
                                              allNotes = snapshot.data!.docs;
                                            }

                                            // Use filtered notes if search is active, otherwise use all notes
                                            List<QueryDocumentSnapshot> notesToDisplay =
                                            isSearching ? filteredNotes : allNotes;

                                            if (isSearching && filteredNotes.isEmpty) {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(vertical: screenheight / 2 - 200),
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Icons.search_off,
                                                      size: 100,
                                                      color: NoteStore.isDarkMode
                                                          ? Colors.white.withOpacity(0.3)
                                                          : Colors.black.withOpacity(0.1),
                                                    ),
                                                    Text(
                                                      'No notes found matching "${searchController.text}"',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: screenwidth <= 545 ? 16 : 18,
                                                        color: NoteStore.isDarkMode
                                                            ? Colors.white.withOpacity(0.6)
                                                            : Colors.black.withOpacity(0.6),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }

                                            return GridView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10,
                                                childAspectRatio: 1,
                                              ),
                                              itemCount: notesToDisplay.length,
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
                                                                () {
                                                              final data = notesToDisplay[index].data() as Map<String, dynamic>?;
                                                              return data?['note']?.toString() ?? '';
                                                            }(),
                                                            style: TextStyle(
                                                              color: NoteStore.isDarkMode ? Colors.white : Colors.black,
                                                              fontSize: 18,
                                                            ),
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
                                                              icon: Icon(
                                                                Icons.edit_outlined,
                                                                color: NoteStore.isDarkMode ? Colors.white : Colors.black,
                                                                size: 20,
                                                              ),
                                                              tooltip: 'Edit',
                                                              onPressed: () async {
                                                                isediting = true;
                                                                final data = notesToDisplay[index].data() as Map<String, dynamic>?;
                                                                final noteText = data?['note']?.toString() ?? '';
                                                                notecontroller.text = noteText;
                                                                editid = notesToDisplay[index].id;
                                                                editText = noteText;
                                                                setState(() {});
                                                              },
                                                            ),
                                                            IconButton(
                                                              icon: Icon(
                                                                Icons.delete_outline,
                                                                color: NoteStore.isDarkMode ? Colors.white : Colors.black,
                                                                size: 20,
                                                              ),
                                                              tooltip: 'Delete',
                                                              onPressed: () async {
                                                                final data = notesToDisplay[index].data() as Map<String, dynamic>?;
                                                                final noteText = data?['note']?.toString() ?? '';

                                                                await FirebaseFirestore.instance.collection("Bin").add({
                                                                  'deletednote': noteText,
                                                                  'creator': FirebaseAuth.instance.currentUser!.uid,
                                                                  'timestamp': FieldValue.serverTimestamp(),
                                                                });
                                                                await FirebaseFirestore.instance
                                                                    .collection("Notes")
                                                                    .doc(notesToDisplay[index].id)
                                                                    .delete();

                                                                // Refresh search results after deletion
                                                                if (isSearching) {
                                                                  searchNotes(searchController.text);
                                                                }
                                                                setState(() {});
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        )
                                            : FutureBuilder(
                                          future: FirebaseFirestore.instance
                                              .collection("Notes")
                                              .orderBy("timestamp")
                                              .where("creator", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Center(
                                                child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
                                              );
                                            }

                                            if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(vertical: screenheight / 2 - 200),
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Icons.lightbulb_outline,
                                                      size: 100,
                                                      color: NoteStore.isDarkMode
                                                          ? Colors.white.withOpacity(0.3)
                                                          : Colors.black.withOpacity(0.1),
                                                    ),
                                                    Text(
                                                      isSearching
                                                          ? 'No notes found matching your search'
                                                          : 'Notes that you add appear here',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: NoteStore.isDarkMode
                                                            ? Colors.white.withOpacity(0.6)
                                                            : Colors.black.withOpacity(0.6),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }

                                            // Store all notes for search
                                            if (snapshot.data != null) {
                                              allNotes = snapshot.data!.docs;
                                            }

                                            // Use filtered notes if search is active, otherwise use all notes
                                            List<QueryDocumentSnapshot> notesToDisplay =
                                            isSearching ? filteredNotes : allNotes;

                                            if (isSearching && filteredNotes.isEmpty) {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(vertical: screenheight / 2 - 200),
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Icons.search_off,
                                                      size: 100,
                                                      color: NoteStore.isDarkMode
                                                          ? Colors.white.withOpacity(0.3)
                                                          : Colors.black.withOpacity(0.1),
                                                    ),
                                                    Text(
                                                      'No notes found matching "${searchController.text}"',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: NoteStore.isDarkMode
                                                            ? Colors.white.withOpacity(0.6)
                                                            : Colors.black.withOpacity(0.6),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }

                                            return ListView.separated(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: notesToDisplay.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    borderRadius: BorderRadius.circular(16),
                                                    border: Border.all(width: 2, color: Colors.deepPurpleAccent),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(screenwidth <= 847 ? 7.60 : 10),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                                () {
                                                              final data = notesToDisplay[index].data() as Map<String, dynamic>?;
                                                              return data?['note']?.toString() ?? '';
                                                            }(),
                                                            style: TextStyle(
                                                              color: NoteStore.isDarkMode ? Colors.white : Colors.black,
                                                              fontSize: 18,
                                                            ),
                                                            softWrap: true,
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.edit_outlined,
                                                            color: NoteStore.isDarkMode ? Colors.white : Colors.black,
                                                            size: 20,
                                                          ),
                                                          tooltip: 'Edit',
                                                          onPressed: () async {
                                                            isediting = true;
                                                            final data = notesToDisplay[index].data() as Map<String, dynamic>?;
                                                            final noteText = data?['note']?.toString() ?? '';
                                                            notecontroller.text = noteText;
                                                            editid = notesToDisplay[index].id;
                                                            editText = noteText;
                                                            setState(() {});
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.delete_outline,
                                                            color: NoteStore.isDarkMode ? Colors.white : Colors.black,
                                                            size: 20,
                                                          ),
                                                          tooltip: 'Delete',
                                                          onPressed: () async {
                                                            final data = notesToDisplay[index].data() as Map<String, dynamic>?;
                                                            final noteText = data?['note']?.toString() ?? '';

                                                            await FirebaseFirestore.instance.collection("Bin").add({
                                                              'deletednote': noteText,
                                                              'creator': FirebaseAuth.instance.currentUser!.uid,
                                                              'timestamp': FieldValue.serverTimestamp(),
                                                            });
                                                            await FirebaseFirestore.instance
                                                                .collection("Notes")
                                                                .doc(notesToDisplay[index].id)
                                                                .delete();

                                                            // Refresh search results after deletion
                                                            if (isSearching) {
                                                              searchNotes(searchController.text);
                                                            }
                                                            setState(() {});
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
                                            );
                                          },
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
                      color: NoteStore.isDarkMode?Colors.grey.shade900:Colors.white70.withAlpha((0.9 * 255).toInt()),
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
        ),
      );
  }
  @override
  Widget build(BuildContext context) {

    if(searchController.text.isEmpty){
      isSearching=false;
    }else{isSearching=true;}


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
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                child: Text('Keep',
                    style: TextStyle(
                      color:NoteStore.isDarkMode?Colors.white:Colors.black ,
                        fontSize:  screenwidth<=990?22:25,
                        fontFamily: 'GilroyFont')
                ),
              ),
              // SizedBox(width:  MediaQuery.of(context).size.width<=990?screenwidth*0.2:100),
              ThTextbox(
                focusNode: searchfocusNode,
                controller: searchController,
                width: screenwidth<=990?screenwidth*0.3:400,
                height: 40,
                text: 'Search',
                prefixicon: Icon(Icons.search,color: NoteStore.isDarkMode?Colors.white:Colors.black,),
                onChanged: (value) => searchNotes(value),
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
                    lowerbuttons:
                    sidebarLowerItems.map((item){
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
                                      SizedBox(height: 10,),
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

                                            ],
                                          ),
                                        ),
                                      ),

                                      isGridview
                                          ? FutureBuilder(
                                        future: FirebaseFirestore.instance
                                            .collection("Notes")
                                            .orderBy("timestamp")
                                            .where("creator", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                            .get(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Center(
                                              child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
                                            );
                                          }

                                          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(vertical: screenheight / 2 - 200),
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.lightbulb_outline,
                                                    size: 100,
                                                    color: NoteStore.isDarkMode
                                                        ? Colors.white.withOpacity(0.3)
                                                        : Colors.black.withOpacity(0.1),
                                                  ),
                                                  Text(
                                                    isSearching
                                                        ? 'No notes found matching your search'
                                                        : 'Notes that you add appear here',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: screenwidth <= 545 ? 20 : 24,
                                                      color: NoteStore.isDarkMode
                                                          ? Colors.white.withOpacity(0.6)
                                                          : Colors.black.withOpacity(0.6),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }

                                          // Store all notes for search
                                          if (snapshot.data != null) {
                                            allNotes = snapshot.data!.docs;
                                          }

                                          // Use filtered notes if search is active, otherwise use all notes
                                          List<QueryDocumentSnapshot> notesToDisplay =
                                          isSearching ? filteredNotes : allNotes;

                                          if (isSearching && filteredNotes.isEmpty) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(vertical: screenheight / 2 - 200),
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.search_off,
                                                    size: 100,
                                                    color: NoteStore.isDarkMode
                                                        ? Colors.white.withOpacity(0.3)
                                                        : Colors.black.withOpacity(0.1),
                                                  ),
                                                  Text(
                                                    'No notes found matching "${searchController.text}"',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: screenwidth <= 545 ? 16 : 18,
                                                      color: NoteStore.isDarkMode
                                                          ? Colors.white.withOpacity(0.6)
                                                          : Colors.black.withOpacity(0.6),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }

                                          return GridView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: screenwidth<=1245?screenwidth<=847?1:2:3,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10,
                                              childAspectRatio: 2,
                                            ),
                                            itemCount: notesToDisplay.length,
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
                                                              () {
                                                            final data = notesToDisplay[index].data() as Map<String, dynamic>?;
                                                            return data?['note']?.toString() ?? '';
                                                          }(),
                                                          style: TextStyle(
                                                            color: NoteStore.isDarkMode ? Colors.white : Colors.black,
                                                            fontSize: 18,
                                                          ),
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
                                                            icon: Icon(
                                                              Icons.edit_outlined,
                                                              color: NoteStore.isDarkMode ? Colors.white : Colors.black,
                                                              size: 20,
                                                            ),
                                                            tooltip: 'Edit',
                                                            onPressed: () async {
                                                              isediting = true;
                                                              final data = notesToDisplay[index].data() as Map<String, dynamic>?;
                                                              final noteText = data?['note']?.toString() ?? '';
                                                              notecontroller.text = noteText;
                                                              editid = notesToDisplay[index].id;
                                                              editText = noteText;
                                                              setState(() {});
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.delete_outline,
                                                              color: NoteStore.isDarkMode ? Colors.white : Colors.black,
                                                              size: 20,
                                                            ),
                                                            tooltip: 'Delete',
                                                            onPressed: () async {
                                                              final data = notesToDisplay[index].data() as Map<String, dynamic>?;
                                                              final noteText = data?['note']?.toString() ?? '';

                                                              await FirebaseFirestore.instance.collection("Bin").add({
                                                                'deletednote': noteText,
                                                                'creator': FirebaseAuth.instance.currentUser!.uid,
                                                                'timestamp': FieldValue.serverTimestamp(),
                                                              });
                                                              await FirebaseFirestore.instance
                                                                  .collection("Notes")
                                                                  .doc(notesToDisplay[index].id)
                                                                  .delete();

                                                              // Refresh search results after deletion
                                                              if (isSearching) {
                                                                searchNotes(searchController.text);
                                                              }
                                                              setState(() {});
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      )
                                          : FutureBuilder(
                                        future: FirebaseFirestore.instance
                                            .collection("Notes")
                                            .orderBy("timestamp")
                                            .where("creator", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                            .get(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Center(
                                              child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
                                            );
                                          }

                                          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(vertical: screenheight / 2 - 200),
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.lightbulb_outline,
                                                    size: 100,
                                                    color: NoteStore.isDarkMode
                                                        ? Colors.white.withOpacity(0.3)
                                                        : Colors.black.withOpacity(0.1),
                                                  ),
                                                  Text(
                                                    isSearching
                                                        ? 'No notes found matching your search'
                                                        : 'Notes that you add appear here',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: NoteStore.isDarkMode
                                                          ? Colors.white.withOpacity(0.6)
                                                          : Colors.black.withOpacity(0.6),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }

                                          // Store all notes for search
                                          if (snapshot.data != null) {
                                            allNotes = snapshot.data!.docs;
                                          }

                                          // Use filtered notes if search is active, otherwise use all notes
                                          List<QueryDocumentSnapshot> notesToDisplay =
                                          isSearching ? filteredNotes : allNotes;

                                          if (isSearching && filteredNotes.isEmpty) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(vertical: screenheight / 2 - 200),
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.search_off,
                                                    size: 100,
                                                    color: NoteStore.isDarkMode
                                                        ? Colors.white.withOpacity(0.3)
                                                        : Colors.black.withOpacity(0.1),
                                                  ),
                                                  Text(
                                                    'No notes found matching "${searchController.text}"',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: NoteStore.isDarkMode
                                                          ? Colors.white.withOpacity(0.6)
                                                          : Colors.black.withOpacity(0.6),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }

                                          return ListView.separated(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: notesToDisplay.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius: BorderRadius.circular(16),
                                                  border: Border.all(width: 2, color: Colors.deepPurpleAccent),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(screenwidth <= 847 ? 7.60 : 10),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                              () {
                                                            final data = notesToDisplay[index].data() as Map<String, dynamic>?;
                                                            return data?['note']?.toString() ?? '';
                                                          }(),
                                                          style: TextStyle(
                                                            color: NoteStore.isDarkMode ? Colors.white : Colors.black,
                                                            fontSize: 18,
                                                          ),
                                                          softWrap: true,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.edit_outlined,
                                                          color: NoteStore.isDarkMode ? Colors.white : Colors.black,
                                                          size: 20,
                                                        ),
                                                        tooltip: 'Edit',
                                                        onPressed: () async {
                                                          isediting = true;
                                                          final data = notesToDisplay[index].data() as Map<String, dynamic>?;
                                                          final noteText = data?['note']?.toString() ?? '';
                                                          notecontroller.text = noteText;
                                                          editid = notesToDisplay[index].id;
                                                          editText = noteText;
                                                          setState(() {});
                                                        },
                                                      ),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.delete_outline,
                                                          color: NoteStore.isDarkMode ? Colors.white : Colors.black,
                                                          size: 20,
                                                        ),
                                                        tooltip: 'Delete',
                                                        onPressed: () async {
                                                          final data = notesToDisplay[index].data() as Map<String, dynamic>?;
                                                          final noteText = data?['note']?.toString() ?? '';

                                                          await FirebaseFirestore.instance.collection("Bin").add({
                                                            'deletednote': noteText,
                                                            'creator': FirebaseAuth.instance.currentUser!.uid,
                                                            'timestamp': FieldValue.serverTimestamp(),
                                                          });
                                                          await FirebaseFirestore.instance
                                                              .collection("Notes")
                                                              .doc(notesToDisplay[index].id)
                                                              .delete();

                                                          // Refresh search results after deletion
                                                          if (isSearching) {
                                                            searchNotes(searchController.text);
                                                          }
                                                          setState(() {});
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
                                          );
                                        },
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