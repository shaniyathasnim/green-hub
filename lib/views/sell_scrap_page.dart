import 'package:flutter/material.dart';
import 'package:green_bin/data/scrap_items_data.dart';
import 'package:green_bin/utils/app_colors.dart';
import 'package:green_bin/views/pickup_confirmed_page.dart';
import 'package:green_bin/widgets/confirm_pickup_dialog.dart';
import 'package:green_bin/widgets/custom_button.dart';
import 'package:green_bin/widgets/custom_text_field.dart';
import 'package:green_bin/widgets/scrap_item_card.dart';

class SellScrapPage extends StatefulWidget {
  const SellScrapPage({super.key});

  @override
  State<SellScrapPage> createState() => _SellScrapPageState();
}

class _SellScrapPageState extends State<SellScrapPage> {
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const ConfirmPickupDialog(),
    ).then((value) {
      if (value == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PickupConfirmedPage()),
        );
      }
    });
  }

  final Set<String> _selectedItems = {};
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedItems.contains(id)) {
        _selectedItems.remove(id);
      } else {
        _selectedItems.add(id);
      }
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 100 ? 2 : 2;
    return Scaffold(
      backgroundColor: White,
      appBar: AppBar(
        backgroundColor: White,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sell Scrap',
          style: TextStyle(
            color: Black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ScrapItemsData.scrapItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 13,
                  mainAxisSpacing: 13,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final item = ScrapItemsData.scrapItems[index];
                  return ScrapItemCard(
                    item: item,
                    isSelected: _selectedItems.contains(item.id),
                    onTap: () => _toggleSelection(item.id),
                  );
                },
              ),
              //form section
              const SizedBox(height: 18),
              CustomTextField(
                controller: _weightController,
                label: "Estimate Weight(KG)",
                hint: " Enter weight",
                prefixIcon: Icon(Icons.scale_outlined, color: CardGreen),
                maxLines: 1,
              ),
              const SizedBox(height: 18),

              CustomTextField(
                controller: _addressController,
                label: "Pickup Address",
                hint: "Enter your address",

                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: CardGreen,
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                text: "Book Pickup",
                onPressed: () {
                  if (_selectedItems.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select at least one item."),
                      ),
                    );
                    return;
                  }
                  _showConfirmationDialog(context);
                },
              ),

              const SizedBox(height: 16),

              // Terms and Info
              const Text(
                "By Booking, you agree to our Terms & Conditions",
                textAlign: TextAlign.center,
                style: TextStyle(color: Grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
