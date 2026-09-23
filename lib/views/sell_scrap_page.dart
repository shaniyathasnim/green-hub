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

  // One weight controller per selected item id, created/disposed dynamically.
  final Map<String, TextEditingController> _weightControllers = {};

  final TextEditingController _addressController = TextEditingController();

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedItems.contains(id)) {
        _selectedItems.remove(id);
        _weightControllers.remove(id)?.dispose();
      } else {
        _selectedItems.add(id);
        _weightControllers[id] = TextEditingController();
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _weightControllers.values) {
      controller.dispose();
    }
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 100 ? 3: 3;

    // Keep the dynamic fields in the same order as the source data list,
    // rather than Set insertion order, so they don't jump around.
    final selectedItemsInOrder = ScrapItemsData.scrapItems
        .where((item) => _selectedItems.contains(item.id))
        .toList();

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
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.0,
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

              // Dynamic per-item weight fields.
              // A field appears the moment its card is selected and is
              // removed the moment it's deselected.
              const SizedBox(height: 18),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: selectedItemsInOrder.isEmpty
                    ? const SizedBox.shrink()
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final item in selectedItemsInOrder) ...[
                      CustomTextField(
                        key: ValueKey(item.id),
                        controller: _weightControllers[item.id]!,
                        label: "Estimated Weight — ${item.title} (KG)",
                        hint: "Enter weight",
                        prefixIcon:
                        const Icon(Icons.scale_outlined, color: CardGreen),
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),

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

                  // Guard: make sure every selected item has a weight entered.
                  final missingWeight = selectedItemsInOrder.any(
                        (item) => (_weightControllers[item.id]?.text.trim().isEmpty ?? true),
                  );
                  if (missingWeight) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter weight for all selected items."),
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