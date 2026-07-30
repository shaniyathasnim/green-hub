import 'package:flutter/material.dart';
import 'package:green_bin/utils/app_colors.dart';
import 'package:green_bin/widgets/custom_button.dart';
import 'package:green_bin/widgets/detail_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:green_bin/views/home_page.dart';


class PickupConfirmedPage extends StatelessWidget {
  const PickupConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:White,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
            child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24,),
            //success icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: CardGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:CardGreen.withOpacity(0.3),
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
const SizedBox(height: 24,),
            //Title &description
            const Text(
              "Pickup Confirmed",
              style: TextStyle(
                color: CardGreen,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8,),
             const Text("Your Pickup Request has been Successfully\n Scheduled.",
             textAlign: TextAlign.center,
             style: TextStyle(
               color: Grey,
               fontSize: 16,
               height: 1.4,
               fontWeight: FontWeight.w300,
             ),

             ),
            const SizedBox(height: 24,),
//Pickup details card
          Container(
            width: double.infinity,
            height:360,
            decoration: BoxDecoration(
              color: LightGrey,
              borderRadius: BorderRadius.circular(24),
              border: const Border(
                top: BorderSide(
                  color: CardGreen,
                  width: 8,
                ),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PICKUP DETAILS",
                    style: TextStyle(
                      color: Black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 16),
                 const DetailInfoTile(
                    icon: Icons.confirmation_number_outlined,
                    label: "Order ID",
                    value: "#1024",
                  ),
                  SizedBox(height: 16),
                 const DetailInfoTile(
                    icon: Icons.calendar_today_outlined,
                    label: "Pickup Date",
                    value: "15 June 2026",
                  ),
                  const DetailInfoTile(
                    icon: Icons.timer_outlined,
                    label: "Pickup Time",
                    value: "10:00 AM-12.00 PM",
                  ),
                  const DetailInfoTile(
                    icon: Icons.location_on_outlined,
                    label: "Pickup Address",
                    value: "Perinthal manna",
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    ),
// Bottom button
  Padding(
    padding: const EdgeInsets.all(24),
    child: CustomButton(
    text: "Back To Home",
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) =>HomePage(),
    ),
    );

  },
  ),),
  ],
  ),
  ),

    );
  }
}
