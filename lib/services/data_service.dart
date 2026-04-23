import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/dua_item.dart';
import '../utils/constants.dart';

class DataService {
  static Future<List<DuaItem>> loadDuas() async {
    try {
      final String jsonString = await rootBundle.loadString(jsonPath);
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((item) => DuaItem.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error loading data: $e');
      return [];
    }
  }
}
