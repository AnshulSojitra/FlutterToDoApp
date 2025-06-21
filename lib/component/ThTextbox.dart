import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThTextbox extends StatefulWidget {
  final String variant; // 'basic', 'password', 'number', 'multiline', 'select'
  final String text;
  final double width;
  final double height;
  const ThTextbox({
    super.key,
    this.variant = 'basic',
    this.text = 'Enter Text',
    this.width=335,
    this.height=50,
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
    Widget? prefixIcon=Icon(Icons.drive_file_rename_outline,size: 14,);
    Widget? suffixIcon;
    // Handle specific variants
    if (widget.variant == 'password') {
      prefixIcon = const Icon(Icons.lock_outline,size: 14,);
      suffixIcon = IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,size: 14,),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.variant == 'number') {
      prefixIcon = const Icon(Icons.phone_android_outlined,size: 14,);
      type = TextInputType.number;
      format = [FilteringTextInputFormatter.digitsOnly];
    } else if (widget.variant == 'multiline') {
      prefixIcon = const Icon(Icons.home_outlined,size: 14,);
      type = TextInputType.multiline;
      maxLines = 5;
    }

    // Handle dropdown variant


    // Default TextField
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextField(
        obscureText: widget.variant == 'password' ? _obscureText : false,
        keyboardType: type,
        maxLines: maxLines,
        inputFormatters: format,
        decoration: InputDecoration(
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
