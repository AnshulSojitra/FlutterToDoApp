import 'package:flutter/material.dart';
class ThErrorCard extends StatefulWidget {
  final String errorMessage;
  const ThErrorCard({super.key,this.errorMessage=''});

  @override
  State<ThErrorCard> createState() => _ThErrorCardState();
}

class _ThErrorCardState extends State<ThErrorCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(
          height: 50,
          width: 400,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            border: Border.all(
              color: Colors.red, // Border color
              width: 1.0,               // Border width
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              widget.errorMessage,
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
  }
}
