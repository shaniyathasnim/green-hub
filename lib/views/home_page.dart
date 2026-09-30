import 'package:flutter/material.dart';
import 'package:green_bin/utils/app_colors.dart';
import 'package:green_bin/views/order_screen.dart';
import 'package:green_bin/views/profile_page.dart';
import 'package:green_bin/views/scrap_item_page.dart';
import 'package:green_bin/views/sell_scrap_page.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../providers/customer_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import 'help_and_support.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedNavIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const OrdersScreen(),
    const HelpSupportScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecentOrders();
    });
  }

  Future<void> _loadRecentOrders() async {
    final customerProvider =
    Provider.of<CustomerProvider>(
      context,
      listen: false,
    );

    final customerId =
        customerProvider.customer?.uid;

    debugPrint(
      'HomePage Customer ID: $customerId',
    );

    if (customerId == null || customerId.isEmpty) {
      return;
    }

    await Provider.of<OrderProvider>(
      context,
      listen: false,
    ).fetchOrders(customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedNavIndex,
        selectedItemColor: CardGreen,
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          setState(() {
            selectedNavIndex = index;
          });

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OrdersScreen(),
              ),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const HelpSupportScreen(),
              ),
            );
          }

          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const ProfileScreen(),
              ),
            );
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.headphones),
            label: "Help",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // Greeting
              RichText(
                text: TextSpan(
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

              // Banner
              ClipRRect(
                borderRadius:
                BorderRadius.circular(10),
                child: Image.asset(
                  "assets/home.png",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              // Menu cards
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius:
                      BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const SellScrapPage(),
                          ),
                        );
                      },
                      child: menuCard(
                        Icons.sell_outlined,
                        "Sell Scrap",
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: InkWell(
                      borderRadius:
                      BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const OrdersScreen(),
                          ),
                        );
                      },
                      child: menuCard(
                        Icons.receipt_long_outlined,
                        "My Orders",
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: double.infinity,
                  child: InkWell(
                    borderRadius:
                    BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const ScrapItemPage(),
                        ),
                      );
                    },
                    child: menuCard(
                      Icons.inventory_2_outlined,
                      "Scrap Items",
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Recent Orders
              const Text(
                "Recent Orders",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

      Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (orderProvider.error != null) {
            return Text(
              'Failed to load recent orders\n\n'
                  '${orderProvider.error}',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            );
          }


          // -----Latest 5 orders-----------------
          final recentOrders =
          orderProvider.orders.take(5).toList();

          if (recentOrders.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No recent orders',
                  style: TextStyle(
                    color: Grey,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          }

          return Column(
            children: recentOrders.map((order) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildOrderCard(order),
              );
            }).toList(),
          );
        },
      ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuCard(
      IconData icon,
      String title,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LightGrey,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: DarkGrey,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: DarkGrey,
              borderRadius:
              BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: CardGreen,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(
      OrderModel order,
      ) {
    final String status =
    order.status == OrderStatus.completed
        ? "Completed"
        : "Active";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: White,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: Green,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // Order ID + Status
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Order ID",
                      style: TextStyle(
                        color: Grey,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      order.orderId,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                        color: Black,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: CardGreen,
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: White,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Amount
          const Text(
            "Pay Amount",
            style: TextStyle(
              color: Grey,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "₹${order.amount.toStringAsFixed(2)}",
            style: const TextStyle(
              color: CardGreen,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          // Date
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: CardGreen,
              ),

              const SizedBox(width: 8),

              Text(
                order.date,
                style: const TextStyle(
                  fontSize: 14,
                  color: Black,
                  fontWeight:
                  FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}