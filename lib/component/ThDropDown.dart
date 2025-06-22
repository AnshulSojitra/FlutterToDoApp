import 'package:flutter/material.dart';
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
    if (widget.variant == 'search') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: widget.width,
            height: widget.height,
            child: TypeAheadFormField<String>(
              getImmediateSuggestions: true,
              textFieldConfiguration: TextFieldConfiguration(
                controller: _controller,
                focusNode: _focusNode, // Attach focus node here
                decoration: InputDecoration(
                  labelText: widget.label,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: const Icon(Icons.search_outlined, size: 14),
                ),
              ),
              suggestionsCallback: (pattern) {
                return widget.options
                    .where((item) => item.toLowerCase().contains(pattern.toLowerCase()))
                    .toList();
              },
              itemBuilder: (context, String suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (String suggestion) {
                _controller.text = suggestion;
                selectedValue = suggestion;
                if (widget.onChanged != null) {
                  widget.onChanged!(suggestion);
                }
              },
              noItemsFoundBuilder: (context) => const Padding(
                padding: EdgeInsets.all(8),
                child: Text('No matches found.'),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an option';
                }
                return null;
              },
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                constraints: const BoxConstraints(
                  maxHeight: 175, // limit dropdown height to avoid overflow
                ),
                elevation: 4,
                color: Colors.white,
                hasScrollbar: true,
              ),
            ),
          ),
          // Show SizedBox only when focused
          if (_isFocused)
            const SizedBox(
              height: 175,
            ),
        ],
      );
    }

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
