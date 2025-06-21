import 'package:flutter/material.dart';
import 'package:untitled1/component/ThAppBar.dart';
import 'package:untitled1/component/ThButton.dart';
import 'package:untitled1/component/ThDropDown.dart';
import 'package:untitled1/component/ThFooter.dart';
import 'package:untitled1/component/ThSideBar.dart';
import 'package:untitled1/component/ThBreadCrumb.dart';


import 'package:untitled1/component/ThTextbox.dart';
class Home extends StatelessWidget {


  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    String jsonString = '[{"menutitle": "home","allowFor": ["admin","user"]},{"menutitle": "Settings","allowFor": ["admin"]}]';
    String currentUserRole="user";
    final List<Map<String, dynamic>> menuItems = [
    { "label": "Home", "icon": "home", "allowFor":["user","admin"] },
    { "label": "Profile", "icon": "person" ,"allowFor":["admin"]},
    { "label": "Settings", "icon": "settings" ,"allowFor":["user","admin"]},];

    Icon logo(String iconName){
      if(iconName=="home"){
        return Icon(Icons.dashboard);
      }
      else if(iconName=="person"){
        return Icon(Icons.person);
      }
      else if(iconName=="settings"){
        return Icon(Icons.settings);
      }
      
      return Icon(Icons.dashboard);
    }
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: ThAppBar(

        leftWidgets: [
          Icon(Icons.home,size: 30,),
          Text('Website',style: TextStyle(fontSize: 25,fontFamily: 'GilroyFont'),),
        ],
        rightWidgets: [
          ThButton(variant: 'dark',text: 'click',),
          ThTextbox(variant: 'password',height: 30,width: 200,),
          ThDropdown(variant:'search',options: ['abc','xyz','pqr'],height: 30,width: 200,),
          ThDropdown(options: ['abc','xyz','pqr'],height: 30,width: 200,)
        ],
      ),
      body: Stack(

        children:[ Row(

            mainAxisAlignment: MainAxisAlignment.start,

          children: [ThSideBar(
             upperbuttons:menuItems.where((item)=>item['allowFor'] is List && item['allowFor'].contains(currentUserRole)).map((item){
               return ThButton(variant:'plain',text: item["label"]!,icon: logo(item['icon']!),);
             }).toList()
          //    [
          //   ThButton(variant:'plain',text: 'dashboard',icon: Icon(Icons.dashboard),),
          //   ThButton(variant:'plain',text: 'settings',icon: Icon(Icons.settings),),
          // ],
            ,
           lowerbuttons: [
             ThButton(variant:'plain',text: 'Get Support',icon: Icon(Icons.contact_support),),
             ThButton(variant:'plain',text: 'Log Out',icon: Icon(Icons.login_outlined),),
           ],
            width: 240,
            color: Colors.white70.withOpacity(0.9) ,
          ),

              
                 Expanded(
                   child: Column(
                     children:[Expanded(
                       child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          scrollbars: false, // 👈 disables platform scrollbars
                        ),
                        child: SingleChildScrollView(
                                       
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              spacing: 15,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                ThBreadcrumb(items:['home','settings','help']),
                                       
                                Row(//row of buttons
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 15,
                                  children: [
                                    ThButton(variant: "primary", text: "btn2"),
                                    ThButton(variant: 'primary-outline', text: "btn3"),
                                    ThButton(variant: 'dark', text: "btn4"),
                                    ThButton(variant: 'dark-outline'),
                                  ]
                              ),
                                ThTextbox(),
                                ThTextbox(variant: 'password',text: 'Enter Password',),
                                ThTextbox(variant: 'number',text: 'Enter number',),
                                ThTextbox(variant: 'multiline',text: 'Enter mulilines',),
                                ThTextbox(variant: 'password',text: 'Enter Password',),
                                ThTextbox(variant: 'number',text: 'Enter number',),
                                ThDropdown(
                                  variant: 'search', // or 'dropdown'
                                  label: 'Fruits',
                                  options: ['peach', 'mang', 'apple'],
                                       
                                ),
                                       
                                ThDropdown(
                                  variant: 'dropdown', // or 'dropdown'
                                  label: 'Gender',
                                  options: ['Male', 'Female', 'Other'],
                                       
                                ),
                                ThTextbox(variant: 'password',height: 30,width: 200,),
                                ThTextbox(variant: 'password',height: 30,width: 200,),
                                ThTextbox(variant: 'password',height: 30,width: 200,),
                                ThTextbox(variant: 'password',height: 30,width: 200,),
                                ThTextbox(variant: 'password',height: 30,width: 200,),
                                       
                            ]),
                          ),
                        ),
                                       ),
                     ),
                       ThFooter(
                         rightWidgets: [
                           ThButton(variant: 'dark-outline',text: 'Back',),
                           ThButton(variant: 'primary',text: 'Continue',)
                         ],
                       ),
                   ]),
                 ),

          ]),

      ]),
      );

  }
}
