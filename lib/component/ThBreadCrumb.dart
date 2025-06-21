import 'package:flutter/material.dart';

class ThBreadcrumb extends StatelessWidget {
  final List<String> items;

  const ThBreadcrumb({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          GestureDetector(
            child: Text(
              items[i],
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: 16
              ),
            ),
          ),
          if (i != items.length - 1)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.chevron_right, size: 16),
            ),
        ]
      ],
    );
  }
}
