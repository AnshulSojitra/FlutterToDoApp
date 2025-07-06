import 'package:flutter/material.dart';
import 'package:untitled1/component/ThAppBar.dart';
import 'package:untitled1/component/ThButton.dart';
import 'package:untitled1/component/ThFooter.dart';
import 'package:untitled1/component/ThSideBar.dart';
import 'package:untitled1/component/ThTextbox.dart';
import 'package:untitled1/pages/NoteStore.dart';
import 'Home.dart';

class Bin extends StatefulWidget {
  final bool deleteclick;
  final List<String> deleteditemslist;
  const Bin({super.key,this.deleteclick=false,required this.deleteditemslist});

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


  @override
  void initState() {

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {});
    // });
    super.initState();
    deleteditems=NoteStore.deletedItems;
    sidebarUpperItems=[
      {'variant':'plain','text':'Notes','icon':Icons.notes_outlined,'onpage':false,'onPress':(){
        Navigator.push(context,
        MaterialPageRoute(builder:(context)=>Home() ),
        );
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
      {'variant':'plain','text':'Settings','icon':Icons.settings_outlined,'onpage':false,'onPress':(){}},
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

  void permanentdeletenote(int index){
    setState(() {
      NoteStore.deletedItems.removeAt(index);
      deleteditems = List.from(NoteStore.deletedItems);
    });

  }

  void restorenote(int index){
    setState(() {
      NoteStore.items.add(NoteStore.deletedItems[index]);
      NoteStore.deletedItems.removeAt(index);
    });
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
            showicontext?Text('Bin', style: TextStyle(fontSize: titlesize, fontFamily: 'GilroyFont')):null,


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
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Bin(deleteditemslist: [],)),
                // );
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
              icon: Icon(Icons.apps,size:18,),
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
                NoteStore.deletedItems.isEmpty?
                    Expanded(
                        child: Center(
                          child: Text('The bin is empty')
                        )
                    )
                    :Row(
                  children: [
                    Expanded(
                      child:SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: isGridview?GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                          ),
                          itemCount: deleteditems.length,
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
                                        deleteditems[index],
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
                                          onPressed: ()=>restorenote(index),
                                          icon: Icon(Icons.restore, size: 20),
                                          tooltip: 'Edit',
                                        ),//Edit button on note
                                        IconButton(
                                          onPressed: () =>permanentdeletenote(index),
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
                          itemCount: NoteStore.deletedItems.length,
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
                                        child: Text(NoteStore.deletedItems[index], style: TextStyle(fontSize: 18),
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(onPressed: ()=>restorenote(index), icon: Icon(Icons.restore,size: 20,),tooltip: 'Restore',),
                                      IconButton(onPressed: ()=>permanentdeletenote(index), icon: Icon(Icons.delete_outline,size: 20,),tooltip: 'Permanent Delete',)
                                    ]),
                              ),
                            );
                          }, separatorBuilder: (BuildContext context, int index) =>SizedBox(height: 10,),
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
                          onPress: (){
                            setState(() {
                              NoteStore.deletedItems.clear();
                            });
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
          ),
        ),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          final screenwidth=MediaQuery.of(context).size.width;
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
                        onPress: (){
                          setState(() {
                            NoteStore.deletedItems.clear();
                          });
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

                    NoteStore.deletedItems.isEmpty?
                        Expanded(
                          child: Center(
                            child: Text('The bin is empty',
                            style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                          ),
                        )
                        :Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: isGridview?GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: screenwidth <= 1245 ? screenwidth <=
                                  847 ? 1 : 2 : 3, // 2 items per row
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 10,
                              childAspectRatio: 3, // Adjust height vs width
                            ),
                            itemCount: deleteditems.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      width: 2, color: Colors.deepPurpleAccent),
                                ),
                        
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      screenwidth <= 847 ? 7.60 : 10),
                                  child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            deleteditems[index],
                                            style: TextStyle(fontSize: 18,color: NoteStore.isDarkMode?Colors.white:Colors.black),
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 5,
                                          ),
                                        ),
                                        Spacer(),
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              IconButton(icon: Icon(
                                                Icons.restore, size: 20,color: NoteStore.isDarkMode?Colors.white:Colors.black,),
                                                tooltip: 'Restore',
                                                onPressed: () =>restorenote(index),),
                                              IconButton(icon: Icon(
                                                Icons.delete_outline, size: 20,color: NoteStore.isDarkMode?Colors.white:Colors.black,),
                                                tooltip: 'Delete',
                                                onPressed: () => permanentdeletenote(index),)
                                            ])
                                      ]),
                                ),
                              );
                            },
                          ):
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: NoteStore.deletedItems.length,
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
                                        child: Text(NoteStore.deletedItems[index], style: TextStyle(fontSize: 18),
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(onPressed: ()=>restorenote(index), icon: Icon(Icons.restore,size: 20,),tooltip: 'Restore',),
                                      IconButton(onPressed: ()=>permanentdeletenote(index), icon: Icon(Icons.delete_outline,size: 20,),tooltip: 'Delete',)
                                    ]),
                              ),
                            );
                          }, separatorBuilder: (BuildContext context, int index) =>SizedBox(height: 10,),
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
