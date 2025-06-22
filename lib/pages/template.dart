import 'package:flutter/material.dart';
import 'package:untitled1/component/ThAppBar.dart';
import 'package:untitled1/component/ThButton.dart';
import 'package:untitled1/component/ThDropDown.dart';

import 'package:untitled1/component/ThTextbox.dart';



class Temp extends StatelessWidget {
  const Temp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThAppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                spacing: 15,
                children: [

              ThButton(variant: 'dark-outline'),
              ThButton(variant: "primary", text: "btn2"),
              ThButton(variant: 'primary-outline', text: "btn3"),
              ThButton(variant: 'dark', text: "btn4"),
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




            ],
          ),
        ),
      ),
    );
  }
}
