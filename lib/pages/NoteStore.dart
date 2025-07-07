
import 'package:flutter/cupertino.dart';

class NoteStore {
  static List<String> items = [];
  static List<String> deletedItems = [];
  static List<int> filteredIndex = [];
  static List<Map<String, dynamic>> labels=[];
  static bool isDarkMode = false;
  static String username = '';
}