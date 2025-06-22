import 'package:flutter/material.dart';
class ThIconBox extends StatelessWidget{
  final double width;
  final double height;
  final String text;
  final Widget? prefixicons;
  final Widget? sufixicons;
  final FocusNode _focusNode = FocusNode();

  ThIconBox({super.key,this.width=200,this.height=40,this.text='Enter Text', this.prefixicons, this.sufixicons});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText:text,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          suffixIcon: Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: sufixicons),
          prefixIcon: Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: prefixicons),

        ),
      ),
    );
  }
}
