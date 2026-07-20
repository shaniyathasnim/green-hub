import 'package:flutter/material.dart';
import 'package:green_bin/models/gb_modelclass.dart';

class ScrapItemsData {


 static final List<ScrapItemModel> scrapItems = [
    ScrapItemModel(
        id: '1',
        title: 'Plastic',
        priceRange: 'Rs 10-/kg',
        icon: Icons.recycling
    ),
    ScrapItemModel(
        id: '2',
        title: 'Paper',
        priceRange: 'Rs 15-/kg',
        icon: Icons.description
    ),
    ScrapItemModel(
        id: '3',
        title: 'Glass',
        priceRange: 'Rs 10-/kg',
        icon: Icons.wine_bar
    ),
    ScrapItemModel(
        id: '4',
        title: 'Metal',
        priceRange: 'Rs 25-/kg',
        icon: Icons.settings_suggest
    ),
    ScrapItemModel(
        id: '5',
        title: 'E-wast',
        priceRange: 'Rs 40-/kg',
        icon: Icons.devices
    ),
    ScrapItemModel(
        id: '6',
        title: 'food',
        priceRange: 'Rs 5-/kg',
        icon: Icons.fastfood_sharp,
    ),
  ];
}