import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/component/ThAppBar.dart';
import 'package:untitled1/component/ThButton.dart';
import 'package:untitled1/component/ThFooter.dart';
import 'package:untitled1/component/ThSideBar.dart';
import 'package:untitled1/component/ThTextbox.dart';
import 'package:untitled1/pages/NoteStore.dart';
import 'Home.dart';
import 'Login.dart';

class Bin extends StatefulWidget {
  final bool deleteclick;

  const Bin({super.key,this.deleteclick=false,});

  @override
  State<Bin> createState() => _BinState();
}

class _BinState extends State<Bin> {
  String currentUserRole = "admin";
  final TextEditingController notecontroller = TextEditingController();
  final TextEditingController labelController = TextEditingController();
  final List<String> items =[];
  late List<String> deleteditems =[];
  final List<ThButton> labels =[];
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNodelabel = FocusNode();



  late int editindex;
  bool opensidebar=true;
  bool showicontext=true;

  bool isGridview=true;

  double iconsize=22;
  double titlesize=20;
  double width=40;
  late List<Map<String, dynamic>> sidebarUpperItems=[];
  late List<Map<String, dynamic>> sidebarLowerItems=[];

  Future<void> logout()async {
    await FirebaseAuth.instance.signOut().then((res) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    });;

  }
  @override
  void initState() {
    super.initState();

    sidebarUpperItems=[
      {'variant':'plain','text':'Notes','icon':Icons.notes_outlined,'onpage':false,'onPress':(){
        Navigator.pushReplacementNamed(context, '/home');

      }},
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
      {'variant':'plain','text':'Log out','icon':Icons.logout,'onpage':false,
        'onPress':()async{
        await logout();
      }},
      {'variant':'plain','text':'Bin','icon':Icons.delete_outline,'onpage':true,'onPress':(){}},
    ];
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
        NoteStore.labels.add({'variant':'plain','text':text,'icon':Icons.label_important_outline,'onpage':false,'onPress':(){}});
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
        backgroundColor:NoteStore.isDarkMode?Colors.black.withOpacity(0.9): Colors.white,
        appBar: ThAppBar(
          leftWidgets: [
            showicontext?IconButton(icon:Icon(Icons.featured_play_list,size: iconsize,color: NoteStore.isDarkMode?Colors.white:Colors.black,),onPressed: (){
              if(opensidebar==true){
                opensidebar=false;
              }else if(opensidebar==false){
                opensidebar=true;
              }
              setState(() {});
            },):null,
            showicontext?Text('Bin', style: TextStyle(fontSize: titlesize, fontFamily: 'GilroyFont',color: NoteStore.isDarkMode?Colors.white:Colors.black,)):null,


          ].whereType<Widget>().toList(),
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
                minWidth: 20,
                minHeight:20,
              ),
              tooltip: 'Refresh',
              icon: Icon(
                Icons.refresh,
                color: NoteStore.isDarkMode?Colors.white:Colors.black,
                size:18,
              ),
              onPressed: () {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Bin(deleteditemslist: [],)),
                // );
              },
            ), //Refresh
            IconButton(
              icon: Icon(
                isGridview?Icons.format_list_bulleted_outlined:Icons.grid_view_outlined,
                color: NoteStore.isDarkMode?Colors.white:Colors.black,
                size:18,
              ),
              tooltip: 'Listview',
              onPressed: toggleview,
              constraints: BoxConstraints(
                minWidth: 20,
              ),
            ),//ListView
            IconButton(
              icon: Icon(Icons.apps,size:18,color: NoteStore.isDarkMode?Colors.white:Colors.black,),
              tooltip: 'Apps',
              onPressed: () {},
              constraints: BoxConstraints(
                minWidth:20,

              ),
            )//Apps
          ],
        ),
        body: SizedBox(
          height:  double.infinity,
          width: double.infinity,
          child: GestureDetector(
              behavior: HitTestBehavior.translucent,
            onTap: (){
              setState(() {
                opensidebar=false;
              });

            },
            child: Stack(
              children: [
                // Main Content (Row without sidebar)
                Row(
                  children: [
                    Expanded(
                      child:SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: isGridview?FutureBuilder(
                          future: FirebaseFirestore.instance.collection("Bin").orderBy("timestamp").where("creator",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
                          builder: (context,snapshot) {
                            if(snapshot.connectionState==ConnectionState.waiting){
                              return Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(color: Colors.deepPurpleAccent,)
                                    ]
                                ),
                              );
                            }
                            if(!snapshot.hasData){
                              return Padding(
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
                            itemCount: snapshot.data!.docs.length,
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
                                          snapshot.data!.docs[index].data()['deletednote'],
                                          style: TextStyle(fontSize: 18,color: NoteStore.isDarkMode?Colors.white:Colors.black,),
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
                                            icon: Icon(Icons.restore, size: 20,color: NoteStore.isDarkMode?Colors.white:Colors.black,),
                                            tooltip: 'Edit',
                                            onPressed: ()async{
                                              await FirebaseFirestore.instance.collection("Notes").add({
                                                'note': snapshot.data!.docs[index].data()['deletednote'],
                                                'creator': FirebaseAuth.instance.currentUser!.uid,
                                                'timestamp': FieldValue.serverTimestamp(),
                                              });
                                              await FirebaseFirestore.instance.collection("Bin").doc(snapshot.data!.docs[index].id).delete();
                                              setState(() {});
                                            },
                                          ),//Edit button on note
                                          IconButton(
                                            icon: Icon(Icons.delete_outline, size: 20,color: NoteStore.isDarkMode?Colors.white:Colors.black,),
                                            tooltip: 'Delete',
                                              onPressed:()async{
                                                await FirebaseFirestore.instance.collection("Bin").doc(snapshot.data!.docs[index].id).delete();
                                                setState(() {
                                                  snapshot.data!.docs.removeAt(index);
                                                });
                                              }
                                          ),//Delete button of note
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );}
                        ):
                        FutureBuilder(
                          future: FirebaseFirestore.instance.collection("Bin").orderBy("timestamp").where("creator",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
                          builder: (context,snapshot) {
                            if(snapshot.connectionState==ConnectionState.waiting){
                              return Center(
                                child: CircularProgressIndicator(color: Colors.deepPurpleAccent,),
                              );
                            }
                            if(!snapshot.hasData){
                              return Padding(
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
                              );
                            }
                            return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
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
                                            snapshot.data!.docs[index].data()['deletednote'],
                                            style: TextStyle(fontSize: 18,color: NoteStore.isDarkMode?Colors.white:Colors.black,),
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Spacer(),
                                        IconButton(
                                          icon: Icon(Icons.restore,size: 20,color: NoteStore.isDarkMode?Colors.white:Colors.black,),
                                          tooltip: 'Restore',
                                          onPressed: ()async{
                                            await FirebaseFirestore.instance.collection("Notes").add({
                                              'note': snapshot.data!.docs[index].data()['deletednote'],
                                              'creator': FirebaseAuth.instance.currentUser!.uid,
                                              'timestamp': FieldValue.serverTimestamp(),
                                            });
                                            await FirebaseFirestore.instance.collection("Bin").doc(snapshot.data!.docs[index].id).delete();
                                            setState(() {});
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete_outline,size: 20,color: NoteStore.isDarkMode?Colors.white:Colors.black,),
                                          tooltip: 'Permanent Delete',
                                          onPressed:()async{
                                            await FirebaseFirestore.instance.collection("Bin").doc(snapshot.data!.docs[index].id).delete();
                                            setState(() {
                                              snapshot.data!.docs.removeAt(index);
                                            });
                                          },
                                        )
                                      ]),
                                ),
                              );
                            }, separatorBuilder: (BuildContext context, int index) =>SizedBox(height: 10,),
                          );}
                        )
                        ,
                      )
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                    child:ThFooter(
                      rightWidgets: [

                        ThButton(
                          variant: 'primary',
                          text: 'Empty bin',
                          onPress: ()async{
                            QuerySnapshot snapshot=await FirebaseFirestore.instance.collection("Bin").where("creator",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
                            for (QueryDocumentSnapshot doc in snapshot.docs) {
                              await doc.reference.delete();
                            }
                            setState(() {});
                          },
                        )
                      ],),
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
        ),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          final screenwidth=MediaQuery.of(context).size.width;
          final screenheight=MediaQuery.of(context).size.height;
          if (screenwidth<=426) {
            return android(screenwidth);
          } else {
            return Scaffold(
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
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child:ThFooter(
                    rightWidgets: [
                      ThButton(
                        variant: 'primary',
                        text: 'Empty bin',
                        onPress: ()async{
                            QuerySnapshot snapshot=await FirebaseFirestore.instance.collection("Bin").where("creator",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
                            for (QueryDocumentSnapshot doc in snapshot.docs) {
                              await doc.reference.delete();
                            }
                            setState(() {});
                        },
                      )
                    ],),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: isGridview?FutureBuilder(
                          future: FirebaseFirestore.instance.collection("Bin").orderBy("timestamp").where("creator",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
                          builder: (context,snapshot) {
                            if(snapshot.connectionState==ConnectionState.waiting){
                              return Center(
                                child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
                              );
                            }
                            if(!snapshot.hasData){
                              return Padding(
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
                              );
                            }
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: screenwidth<=1245?screenwidth<=847?1:2:3, // 2 items per row
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 10,
                                childAspectRatio: 2, // Adjust height vs width
                              ),

                              itemCount: snapshot.data!.docs.length,//isSearching?NoteStore.filteredIndex.length:NoteStore.items.length,//
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
                                              snapshot.data!.docs[index].data()['deletednote'],
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
                                                  onPressed: ()async{
                                                    await FirebaseFirestore.instance.collection("Notes").add({
                                                      'note': snapshot.data!.docs[index].data()['deletednote'],
                                                      'creator': FirebaseAuth.instance.currentUser!.uid,
                                                      'timestamp': FieldValue.serverTimestamp(),
                                                    });
                                                    await FirebaseFirestore.instance.collection("Bin").doc(snapshot.data!.docs[index].id).delete();
                                                    setState(() {});
                                                  },
                                                  icon: Icon(Icons.restore, size: 20,color: NoteStore.isDarkMode?Colors.white:Colors.black,),
                                                  tooltip: 'Edit',
                                                ),
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.delete_outline,size: 20,
                                                      color: NoteStore.isDarkMode?Colors.white:Colors.black,
                                                    ),
                                                    tooltip: 'Delete',
                                                    onPressed:()async{
                                                      await FirebaseFirestore.instance.collection("Bin").doc(snapshot.data!.docs[index].id).delete();
                                                      setState(() {
                                                        snapshot.data!.docs.removeAt(index);
                                                      });
                                                    }
                                                )
                                              ])
                                        ]),
                                  ),
                                );
                              },
                            );
                          },
                        ):
                        FutureBuilder(
                          future: FirebaseFirestore.instance.collection("Bin").orderBy("timestamp").where("creator",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
                          builder: (context,snapshot){
                            if(snapshot.connectionState==ConnectionState.waiting){
                              return Center(
                                child: CircularProgressIndicator(color: Colors.deepPurpleAccent,),
                              );
                            }
                            if(!snapshot.hasData){
                              return Padding(
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
                              );
                            }
                            return ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
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
                                            snapshot.data!.docs[index].data()['deletednote'],
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: NoteStore.isDarkMode?Colors.white:Colors.black,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        IconButton(
                                          icon: Icon(Icons.restore,size: 20,color: NoteStore.isDarkMode?Colors.white:Colors.black,),
                                          tooltip: 'Restore',
                                          onPressed: ()async{
                                            await FirebaseFirestore.instance.collection("Notes").add({
                                              'note': snapshot.data!.docs[index].data()['deletednote'],
                                              'creator': FirebaseAuth.instance.currentUser!.uid,
                                              'timestamp': FieldValue.serverTimestamp(),
                                            });
                                            await FirebaseFirestore.instance.collection("Bin").doc(snapshot.data!.docs[index].id).delete();
                                            setState(() {});
                                            },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete_outline,size: 20,color: NoteStore.isDarkMode?Colors.white:Colors.black,),
                                          tooltip: 'Delete',
                                          onPressed:()async{
                                            await FirebaseFirestore.instance.collection("Bin").doc(snapshot.data!.docs[index].id).delete();
                                            setState(() {
                                              snapshot.data!.docs.removeAt(index);
                                            });
                                            },
                                        )
                                      ]),
                                ),
                              );
                            }, separatorBuilder: (BuildContext context, int index) =>SizedBox(height: 10,),
                          );},
                        ),
                      ),
                    )

                  ],
                ),
              ],
            ),
          );
          }
        }
    );

  }
}
