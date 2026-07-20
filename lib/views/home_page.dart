import 'package:flutter/material.dart';
import 'package:green_bin/utils/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: CardGreen,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Orders"),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: "Help",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Greeting
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Hello,",
                      style: TextStyle(
                        color: CardGreen,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "Alex",
                      style: TextStyle(
                        color: Black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //Banner
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/home.png",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              //Menu card
              Row(
                children: [
                  Expanded(child: menuCard(Icons.sell_outlined, "Sell Scrap")),
                  const SizedBox(width: 10),
                  Expanded(
                    child: menuCard(Icons.receipt_long_outlined, "My Orders"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: double.infinity,
                  child: menuCard(Icons.inventory_2_outlined, "Scrap Items"),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Recent Orders",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              orderCard(
                id: "#SG-89421",
                amount: "Rs 50",
                date: "12/02/2026",
                status: "Active",
              ),
              const SizedBox(height: 16),
              orderCard(
                id: "#SG-8452",
                amount: "RS 50",
                date: "10/02/2026",
                status: "Completed",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuCard(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LightGrey,
        borderRadius: BorderRadius.circular(18),
        border: BoxBorder.all(color: DarkGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: DarkGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: CardGreen),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget orderCard({
    required String id,
    required String amount,
    required String date,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: White,
        borderRadius: BorderRadius.circular(18),
        border: BoxBorder.all(color: CardGreen),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Order ID", style: TextStyle(color: Grey)),
                  const SizedBox(height: 5),
                  Text(
                    id,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: CardGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: White,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              const Text(
                "Pay Amount:",
                style: TextStyle(color: Grey, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                amount,
                style: const TextStyle(
                  color: CardGreen,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: CardGreen),
                  const SizedBox(width: 6),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
