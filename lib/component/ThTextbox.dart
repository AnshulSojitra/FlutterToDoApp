import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThTextbox extends StatefulWidget {
  final String variant; // 'basic', 'password', 'number', 'multiline', 'select'
  final String text;
  final double width;
  final double height;
  final Icon? prefixicon;
  final Icon? suffixicon;
  final GestureTapCallback? onTap;
  final FocusNode? focusNode ;
  final TapRegionCallback? onTapOutside;
  final TextEditingController? controller;
  final Function(String)?  onSubmitted;
  const ThTextbox({
    super.key,
    this.variant = 'basic',
    this.text = 'Enter Text',
    this.width=335,
    this.height=50,
    this.prefixicon,
    this.suffixicon,
    this.onTap,
    this.focusNode,
    this.onTapOutside,
    this.controller,
    this.onSubmitted,
  });

  @override
  State<ThTextbox> createState() => _ThTextboxState();
}

class _ThTextboxState extends State<ThTextbox> {
  bool _obscureText = true;
  String selectedValue = 'x';

  @override
  Widget build(BuildContext context) {
    // Default values
    TextInputType? type;
    List<TextInputFormatter>? format;
    int maxLines = 1;
    Widget? prefixIcon=widget.prefixicon;
    Widget? suffixIcon=widget.suffixicon;
    // Handle specific variants
    if (widget.variant == 'password') {
      prefixIcon = widget.prefixicon;
      suffixIcon = IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,size: 14,),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.variant == 'number') {
      prefixIcon = widget.prefixicon;
      suffixIcon=widget.suffixicon;
      type = TextInputType.number;
      format = [FilteringTextInputFormatter.digitsOnly];
    } else if (widget.variant == 'multiline') {
      prefixIcon = widget.prefixicon;
      suffixIcon=widget.suffixicon;
      type = TextInputType.multiline;
      maxLines = 5;
    }

    // Handle dropdown variant


    // Default TextField
    return Container(
      constraints: BoxConstraints(


      ),
      width: widget.width,
      height: 40,
      child: TextField(
        onSubmitted: widget.onSubmitted,
        controller: widget.controller,
        onTapOutside: widget.onTapOutside,
        focusNode: widget.focusNode,
        onTap: widget.onTap,
        obscureText: widget.variant == 'password' ? _obscureText : false,
        keyboardType: type,
        maxLines: maxLines,
        inputFormatters: format,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),),
          isDense: true,
          labelText: widget.text,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
