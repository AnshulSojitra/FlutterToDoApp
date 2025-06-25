import 'package:flutter/material.dart';
class ThIconBox extends StatefulWidget{
  final double width;
  final double height;
  final String text;
  final Widget? prefixicons;
  final Widget? sufixicons;
  final TextEditingController controller;
  final GestureTapCallback? onTap;
  final Function(String)? onSubmitted;

  ThIconBox({super.key,this.width=200,this.height=40,this.text='Enter Text', this.prefixicons, this.sufixicons,required this.controller, this.onSubmitted, this.onTap,});

  @override
  State<ThIconBox> createState() => _ThIconBoxState();
}

class _ThIconBoxState extends State<ThIconBox> {


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextField(
        onTap: widget.onTap,
        onSubmitted: widget.onSubmitted,
        controller: widget.controller,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText:widget.text,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          suffixIcon: Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: widget.sufixicons),
          prefixIcon: Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: widget.prefixicons),

        ),
      ),
    );
  }
}
