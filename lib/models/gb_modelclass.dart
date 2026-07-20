import 'package:flutter/material.dart';

class ScrapItemModel {
  final String id;
  final String title;
  final String priceRange;
  final IconData icon;
  final Color color;

  const ScrapItemModel({
    required this.id,
    required this.title,
    required this.priceRange,
    required this.icon,
    this.color = Colors.grey,
  });
}