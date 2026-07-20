import 'package:flutter/material.dart';
import 'package:green_bin/data/scrap_items_data.dart';
import 'package:green_bin/utils/app_colors.dart';
import 'package:green_bin/widgets/scrap_card.dart';

class ScrapItemPage extends StatefulWidget {
  const ScrapItemPage({super.key});


  @override
  State<ScrapItemPage> createState() => _ScrapItemPageState();
}

class _ScrapItemPageState extends State<ScrapItemPage> {

  @override

  Widget build(BuildContext context) {
    //determine screen width
    final double screenWidth = MediaQuery.of(context).size.width;
    //2 columns for phone 4 for tables
    final int crossAxisCount = screenWidth > 600 ? 4 : 2;
    return Scaffold(
backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Scrap Items",
            style: TextStyle(
              color: Black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 15),
        // Grid Section
        Expanded(
            child: GridView.builder(

                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9, // Balanced card height

                ),
                itemCount: ScrapItemsData.scrapItems.length,
                itemBuilder: (context, index) {
                  final item = ScrapItemsData.scrapItems[index];
                  return ScrapCard(
                    item: item,
                    onTap: () {
                      // Logic for item selection
                      debugPrint("Selected: ${item.title}");
                    },
                  );
                },
            ),
        ),
        // Bottom Info (Optional)
        Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
                child: Text(
                  "Check the latest market prices for your recyclable items.Prices are subject to quality and purity.",
                  style: TextStyle(
                    color: Grey,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ),
        ),
                ],
            ),
        ),
    );
  }
}