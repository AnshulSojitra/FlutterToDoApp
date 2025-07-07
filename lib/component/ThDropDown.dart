import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class ThDropdown extends StatefulWidget {
  final String variant; // 'search' or any other value
  final String label;
  final List<String> options;
  final ValueChanged<String>? onChanged;
  final double width;
  final double height;
  const ThDropdown({super.key,

    this.variant = 'dropdown',
    this.label = 'Select Option',
    required this.options,
    this.onChanged,
    this.width=335,
    this.height=50,
  }) ;

  @override
  State<ThDropdown> createState() => _ThDropdownState();
}

class _ThDropdownState extends State<ThDropdown> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController cont = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String? selectedValue;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });

    selectedValue = null;
    _controller.text = selectedValue ?? '';
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    // Normal dropdown variant
    return DropdownMenu<String>(

      width: widget.width,
      controller: cont,
      label: Text(widget.label),
      leadingIcon: const Icon(Icons.person_outline_sharp, size: 14),
      trailingIcon: const Icon(Icons.arrow_drop_down, size: 14),
      selectedTrailingIcon: const Icon(Icons.arrow_drop_up, size: 15),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        isDense: true,
        constraints: BoxConstraints.tight(Size.fromHeight(widget.height)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      dropdownMenuEntries: widget.options
          .map((index) => DropdownMenuEntry(value: index, label: index))
          .toList(),
      onSelected: (value) {
        setState(() {
          selectedValue = value;
        });
      },
    );


  }
}
