import 'package:flutter/material.dart';
import 'package:green_bin/utils/app_colors.dart';
import 'package:green_bin/widgets/custom_button.dart';
import 'package:green_bin/widgets/detail_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:green_bin/views/home_page.dart';

class PickupConfirmedPage extends StatelessWidget {
  final String orderId;
  final List<String> selectedItems;
  final Map<String, double> weights;
  final String pickupAddress;
  const PickupConfirmedPage({
    super.key,
    required this.orderId,
    required this.selectedItems,
    required this.weights,
    required this.pickupAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: White,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    //-------success icon----------
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: CardGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: CardGreen.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: White,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 24),
                    //Title &description
                    const Text(
                      "Pickup Confirmed",
                      style: TextStyle(
                        color: CardGreen,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Your Pickup Request has been Successfully\n Scheduled.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Grey,
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 24),

                    //----------Pickup details card------------
                    Container(
                      width: double.infinity,
                      height: 360,
                      decoration: BoxDecoration(
                        color: LightGrey,
                        borderRadius: BorderRadius.circular(24),
                        border: const Border(
                          top: BorderSide(color: CardGreen, width: 8),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "PICKUP DETAILS",
                              style: TextStyle(
                                color: Black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            DetailInfoTile(
                              icon: Icons.confirmation_number_outlined,
                              label: "Order ID",
                              value: "#$orderId",
                            ),

                            const SizedBox(height: 12),

                            // PICKUP ADDRESS
                            DetailInfoTile(
                              icon: Icons.location_on_outlined,
                              label: "Pickup Address",
                              value: pickupAddress,
                            ),
                            // -----------SELECTED ITEMS----------
                            const SizedBox(height: 12),
                            const Text(
                              "Selected Items",
                              style: TextStyle(
                                color: Black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...selectedItems.map((item) {
                              final double weight = weights[item] ?? 0;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.recycling,
                                      size: 20,
                                      color: CardGreen,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          color: Black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${weight.toStringAsFixed(1)} kg",
                                      style: const TextStyle(
                                        color: CardGreen,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //---------- Bottom button-----------

            Padding(
              padding: const EdgeInsets.all(24),
              child: CustomButton(
                text: "Back To Home",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
