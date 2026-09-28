import 'package:flutter/material.dart';
import 'package:green_bin/utils/app_colors.dart';
import 'package:green_bin/views/pickup_confirmed_page.dart';
import 'package:green_bin/widgets/custom_dialog_button.dart';
class ConfirmPickupDialog extends StatelessWidget {
  const ConfirmPickupDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
      backgroundColor: White,
      child: Container(
        padding: const EdgeInsets.all(25),
        constraints: const BoxConstraints(maxWidth: 350),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Dialog takes only required height
          children: [
            // Success Icon with Glow
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: CardGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: CardGreen.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: White,
                size: 45,
              ),
            ),
            const SizedBox(height: 25),

            // Title
            const Text(
              "Confirm Pickup",
              style: TextStyle(
                color: CardGreen,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle
            const Text(
              "Are You Sure You Want To Book ?",
              style: TextStyle(
                color: Black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 35),

            // Buttons Row
            Row(
              children: [
                Expanded(
                  child: CustomDialogButton(
                    text: "Cancel",
                    isPrimary: false,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: CustomDialogButton(
                    text: "Done",
                    onPressed: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => const PickupConfirmedPage(),));
                      // // Logic for confirmation
                    Navigator.pop(context, true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

