import 'package:flutter/material.dart';
import 'package:green_bin/data/scrap_items_data.dart';
import 'package:green_bin/utils/app_colors.dart';
import 'package:green_bin/views/pickup_confirmed_page.dart';
import 'package:green_bin/widgets/confirm_pickup_dialog.dart';
import 'package:green_bin/widgets/custom_button.dart';
import 'package:green_bin/widgets/custom_text_field.dart';
import 'package:green_bin/widgets/scrap_item_card.dart';
import 'package:provider/provider.dart';

import '../providers/customer_provider.dart';

class SellScrapPage extends StatefulWidget {
  const SellScrapPage({super.key});

  @override
  State<SellScrapPage> createState() => _SellScrapPageState();
}

class _SellScrapPageState extends State<SellScrapPage> {
  // Selected scrap items
  final Set<String> _selectedItems = {};

  // Weight controllers
  final Map<String, TextEditingController> _weightControllers = {};

  // Pickup address
  final TextEditingController _addressController =
  TextEditingController();

  // ============================================================
  // SELECT / UNSELECT SCRAP ITEM
  // ============================================================

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

  // ============================================================
  // VALIDATE WEIGHTS
  // ============================================================

  bool _validateWeights() {
    for (final String item in _selectedItems) {
      final TextEditingController? controller =
      _weightControllers[item];

      if (controller == null ||
          controller.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please enter the weight for $item.',
            ),
          ),
        );

        return false;
      }

      final double? weight =
      double.tryParse(controller.text.trim());

      if (weight == null || weight <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please enter a valid weight for $item.',
            ),
          ),
        );

        return false;
      }
    }

    return true;
  }

  // ============================================================
  // SHOW CONFIRMATION + CREATE FIRESTORE ORDER
  // ============================================================

  Future<void> _showConfirmationDialog() async {
    // ----------------------------------------------------------
    // SHOW CONFIRMATION DIALOG
    // ----------------------------------------------------------

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return const ConfirmPickupDialog();
      },
    );

    // User cancelled
    if (confirmed != true) {
      return;
    }

    // ----------------------------------------------------------
    // CHECK SELECTED ITEMS
    // ----------------------------------------------------------

    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select at least one item.',
          ),
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // CHECK WEIGHTS
    // ----------------------------------------------------------

    if (!_validateWeights()) {
      return;
    }

    // ----------------------------------------------------------
    // GET ADDRESS
    // ----------------------------------------------------------

    final String address =
    _addressController.text.trim();

    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your pickup address.',
          ),
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // PREPARE SELECTED ITEMS
    // ----------------------------------------------------------

    final List<String> selectedItems =
    _selectedItems.toList();

    // ----------------------------------------------------------
    // PREPARE WEIGHTS
    // ----------------------------------------------------------

    final Map<String, double> weights = {};

    for (final String item in _selectedItems) {
      final double weight = double.parse(
        _weightControllers[item]!.text.trim(),
      );

      weights[item] = weight;
    }

    // ----------------------------------------------------------
    // GET CUSTOMER PROVIDER
    // ----------------------------------------------------------

    final CustomerProvider customerProvider =
    Provider.of<CustomerProvider>(
      context,
      listen: false,
    );

    // ----------------------------------------------------------
    // CHECK CUSTOMER LOGIN
    // ----------------------------------------------------------

    if (customerProvider.customer == null ||
        customerProvider.customer!.uid == null ||
        customerProvider.customer!.uid!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please login before booking a pickup.',
          ),
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // SHOW LOADING
    // ----------------------------------------------------------

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: CardGreen,
          ),
        );
      },
    );

    // ----------------------------------------------------------
    // CREATE FIRESTORE ORDER
    // ----------------------------------------------------------

    try {
      final String orderId =
      await customerProvider.createPickupOrder(
        selectedItems: selectedItems,
        weights: weights,
        pickupAddress: address,
      );

      if (!mounted) {
        return;
      }

      // Close loading dialog
      Navigator.pop(context);

      // --------------------------------------------------------
      // GO TO CONFIRMED PAGE
      // --------------------------------------------------------

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return PickupConfirmedPage(
              orderId: orderId,
              selectedItems: selectedItems,
              weights: weights,
              pickupAddress: address,
            );
          },
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      // Close loading dialog
      Navigator.pop(context);

      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    for (final controller
    in _weightControllers.values) {
      controller.dispose();
    }

    _addressController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final double screenWidth =
        MediaQuery.of(context).size.width;

    final int crossAxisCount =
    screenWidth > 600 ? 4 : 3;

    final selectedItemsInOrder =
    ScrapItemsData.scrapItems
        .where(
          (item) =>
          _selectedItems.contains(item.id),
    )
        .toList();

    return Scaffold(
      backgroundColor: White,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: White,
        elevation: 0,
        centerTitle: false,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Black,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
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

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------
              // SCRAP ITEMS
              // ------------------------------------------------

              GridView.builder(
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),

                itemCount:
                ScrapItemsData.scrapItems.length,

                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                  crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.0,
                ),

                itemBuilder: (context, index) {
                  final item =
                  ScrapItemsData.scrapItems[index];

                  return ScrapItemCard(
                    item: item,

                    isSelected:
                    _selectedItems.contains(
                      item.id,
                    ),

                    onTap: () {
                      _toggleSelection(item.id);
                    },
                  );
                },
              ),

              const SizedBox(height: 18),

              // ------------------------------------------------
              // WEIGHT FIELDS
              // ------------------------------------------------

              AnimatedSize(
                duration:
                const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,

                child:
                selectedItemsInOrder.isEmpty
                    ? const SizedBox.shrink()
                    : Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    for (final item
                    in selectedItemsInOrder) ...[
                      CustomTextField(
                        key: ValueKey(
                          item.id,
                        ),

                        controller:
                        _weightControllers[
                        item.id]!,

                        label:
                        'Estimated Weight — ${item.title} (KG)',

                        hint:
                        'Enter weight',

                        prefixIcon:
                        const Icon(
                          Icons
                              .scale_outlined,
                          color: CardGreen,
                        ),

                        maxLines: 1,

                        keyboardType:
                        const TextInputType
                            .numberWithOptions(
                          decimal: true,
                        ),
                      ),

                      const SizedBox(
                        height: 14,
                      ),
                    ],
                  ],
                ),
              ),

              // ------------------------------------------------
              // ADDRESS
              // ------------------------------------------------

              CustomTextField(
                controller:
                _addressController,

                label: 'Pickup Address',

                hint: 'Enter your address',

                prefixIcon:
                const Icon(
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

      // ========================================================
      // BOOK PICKUP
      // ========================================================

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            16,
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                text: 'Book Pickup',

                onPressed: () {
                  if (_selectedItems.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please select at least one item.',
                        ),
                      ),
                    );

                    return;
                  }

                  final bool missingWeight =
                  selectedItemsInOrder.any(
                        (item) {
                      return _weightControllers[
                      item.id]
                          ?.text
                          .trim()
                          .isEmpty ??
                          true;
                    },
                  );

                  if (missingWeight) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter weight for all selected items.',
                        ),
                      ),
                    );

                    return;
                  }

                  // Open confirmation dialog
                  _showConfirmationDialog();
                },
              ),

              const SizedBox(height: 16),

              const Text(
                'By Booking, you agree to our Terms & Conditions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}